#include "rive_plutovg.hpp"

#include "rive/shapes/paint/color.hpp"

#include <algorithm>
#include <cstdio>

namespace rive_plutovg
{
namespace
{

plutovg_matrix_t toVg(const rive::Mat2D& m)
{
  return plutovg_matrix_t{m[0], m[1], m[2], m[3], m[4], m[5]};
}

plutovg_color_t toVg(rive::ColorInt c)
{
  return plutovg_color_t{rive::colorRed(c) / 255.0f,
                         rive::colorGreen(c) / 255.0f,
                         rive::colorBlue(c) / 255.0f,
                         rive::colorAlpha(c) / 255.0f};
}

plutovg_fill_rule_t toVg(rive::FillRule rule)
{
  switch (rule)
  {
    case rive::FillRule::evenOdd:
      return PLUTOVG_FILL_RULE_EVEN_ODD;
    case rive::FillRule::clockwise:
      // Clockwise keeps only clockwise-wound areas; non-zero is the closest
      // rule PlutoVG has, and matches for paths that never wind backwards.
      unsupported().clockwiseFill++;
      return PLUTOVG_FILL_RULE_NON_ZERO;
    case rive::FillRule::nonZero:
    default:
      return PLUTOVG_FILL_RULE_NON_ZERO;
  }
}

plutovg_line_cap_t toVg(rive::StrokeCap cap)
{
  switch (cap)
  {
    case rive::StrokeCap::round:
      return PLUTOVG_LINE_CAP_ROUND;
    case rive::StrokeCap::square:
      return PLUTOVG_LINE_CAP_SQUARE;
    default:
      return PLUTOVG_LINE_CAP_BUTT;
  }
}

plutovg_line_join_t toVg(rive::StrokeJoin join)
{
  switch (join)
  {
    case rive::StrokeJoin::round:
      return PLUTOVG_LINE_JOIN_ROUND;
    case rive::StrokeJoin::bevel:
      return PLUTOVG_LINE_JOIN_BEVEL;
    default:
      return PLUTOVG_LINE_JOIN_MITER;
  }
}

} // namespace

Unsupported& unsupported()
{
  static Unsupported counts;
  return counts;
}

DrawCost& drawCost()
{
  static DrawCost cost;
  return cost;
}

namespace
{
uint32_t micros()
{
  using namespace std::chrono;
  return static_cast<uint32_t>(
      duration_cast<microseconds>(steady_clock::now().time_since_epoch())
          .count());
}
} // namespace

// ---- Path ----

Path::Path(rive::RawPath& rawPath, rive::FillRule fillRule) :
    m_raw(rawPath), m_fillRule(fillRule)
{}

Path::~Path()
{
  if (m_vg != nullptr)
  {
    plutovg_path_destroy(m_vg);
  }
}

void Path::rewind()
{
  m_raw.rewind();
  m_dirty = true;
}

void Path::addRenderPath(const rive::RenderPath* path,
                         const rive::Mat2D& transform)
{
  m_raw.addPath(static_cast<const Path*>(path)->m_raw, &transform);
  m_dirty = true;
}

void Path::moveTo(float x, float y)
{
  m_raw.moveTo(x, y);
  m_dirty = true;
}

void Path::lineTo(float x, float y)
{
  m_raw.injectImplicitMoveIfNeeded();
  m_raw.line({x, y});
  m_dirty = true;
}

void Path::cubicTo(float ox, float oy, float ix, float iy, float x, float y)
{
  m_raw.injectImplicitMoveIfNeeded();
  m_raw.cubic({ox, oy}, {ix, iy}, {x, y});
  m_dirty = true;
}

void Path::close()
{
  m_raw.close();
  m_dirty = true;
}

void Path::addRawPath(const rive::RawPath& path)
{
  m_raw.addPath(path, nullptr);
  m_dirty = true;
}

const plutovg_path_t* Path::vg() const
{
  if (m_vg == nullptr)
  {
    m_vg = plutovg_path_create();
  }
  if (!m_dirty)
  {
    return m_vg;
  }
  plutovg_path_reset(m_vg);
  auto verbs = m_raw.verbs();
  auto points = m_raw.points();
  size_t p = 0;
  for (size_t i = 0; i < verbs.size(); ++i)
  {
    switch (verbs[i])
    {
      case rive::PathVerb::move:
        plutovg_path_move_to(m_vg, points[p].x, points[p].y);
        p += 1;
        break;
      case rive::PathVerb::line:
        plutovg_path_line_to(m_vg, points[p].x, points[p].y);
        p += 1;
        break;
      case rive::PathVerb::quad:
        plutovg_path_quad_to(m_vg,
                             points[p].x,
                             points[p].y,
                             points[p + 1].x,
                             points[p + 1].y);
        p += 2;
        break;
      case rive::PathVerb::cubic:
        plutovg_path_cubic_to(m_vg,
                              points[p].x,
                              points[p].y,
                              points[p + 1].x,
                              points[p + 1].y,
                              points[p + 2].x,
                              points[p + 2].y);
        p += 3;
        break;
      case rive::PathVerb::close:
        plutovg_path_close(m_vg);
        break;
    }
  }
  m_dirty = false;
  return m_vg;
}

// ---- Gradient ----

Gradient::Gradient(Kind k,
                   const float g[4],
                   const rive::ColorInt colors[],
                   const float offsets[],
                   size_t count) :
    kind(k)
{
  for (int i = 0; i < 4; ++i)
  {
    geometry[i] = g[i];
  }
  stops.reserve(count);
  for (size_t i = 0; i < count; ++i)
  {
    stops.push_back(plutovg_gradient_stop_t{offsets[i], toVg(colors[i])});
  }
}

// ---- Paint ----

void Paint::feather(float value)
{
  if (value > 0.0f)
  {
    unsupported().feather++;
  }
}

void Paint::apply(plutovg_canvas_t* canvas) const
{
  if (m_blend != rive::BlendMode::srcOver)
  {
    unsupported().blendMode++;
  }
  if (m_shader != nullptr)
  {
    auto* g = static_cast<const Gradient*>(m_shader.get());
    plutovg_matrix_t local = toVg(m_shaderTransform);
    const plutovg_matrix_t* matrix =
        m_shaderTransform == rive::Mat2D() ? nullptr : &local;
    const int count = static_cast<int>(g->stops.size());
    if (g->kind == Gradient::Kind::linear)
    {
      plutovg_canvas_set_linear_gradient(canvas,
                                         g->geometry[0],
                                         g->geometry[1],
                                         g->geometry[2],
                                         g->geometry[3],
                                         PLUTOVG_SPREAD_METHOD_PAD,
                                         g->stops.data(),
                                         count,
                                         matrix);
    }
    else
    {
      plutovg_canvas_set_radial_gradient(canvas,
                                         g->geometry[0],
                                         g->geometry[1],
                                         g->geometry[2],
                                         g->geometry[0],
                                         g->geometry[1],
                                         0.0f,
                                         PLUTOVG_SPREAD_METHOD_PAD,
                                         g->stops.data(),
                                         count,
                                         matrix);
    }
  }
  else
  {
    plutovg_color_t color = toVg(m_color);
    plutovg_canvas_set_color(canvas, &color);
  }
  if (isStroke())
  {
    plutovg_canvas_set_line_width(canvas, m_thickness);
    plutovg_canvas_set_line_cap(canvas, toVg(m_cap));
    plutovg_canvas_set_line_join(canvas, toVg(m_join));
    plutovg_canvas_set_miter_limit(canvas, 4.0f);
  }
}

float Paint::maxAlpha() const
{
  if (m_shader == nullptr)
  {
    return rive::colorAlpha(m_color) / 255.0f;
  }
  float alpha = 0.0f;
  for (const auto& stop : static_cast<const Gradient*>(m_shader.get())->stops)
  {
    alpha = std::max(alpha, stop.color.a);
  }
  return alpha;
}

// ---- Image and buffer ----

Image::Image(plutovg_surface_t* surface) : m_surface(surface)
{
  m_Width = plutovg_surface_get_width(surface);
  m_Height = plutovg_surface_get_height(surface);
}

Image::~Image() { plutovg_surface_destroy(m_surface); }

Buffer::Buffer(rive::RenderBufferType type,
               rive::RenderBufferFlags flags,
               size_t sizeInBytes) :
    rive::RenderBuffer(type, flags, sizeInBytes), m_bytes(sizeInBytes)
{}

// ---- Factory ----

rive::rcp<rive::RenderBuffer> Factory::makeRenderBuffer(
    rive::RenderBufferType type,
    rive::RenderBufferFlags flags,
    size_t size)
{
  return rive::make_rcp<Buffer>(type, flags, size);
}

rive::rcp<rive::RenderShader> Factory::makeLinearGradient(
    float sx,
    float sy,
    float ex,
    float ey,
    const rive::ColorInt colors[],
    const float stops[],
    size_t count)
{
  const float g[4] = {sx, sy, ex, ey};
  return rive::make_rcp<Gradient>(Gradient::Kind::linear,
                                  g,
                                  colors,
                                  stops,
                                  count);
}

rive::rcp<rive::RenderShader> Factory::makeRadialGradient(
    float cx,
    float cy,
    float radius,
    const rive::ColorInt colors[],
    const float stops[],
    size_t count)
{
  const float g[4] = {cx, cy, radius, 0.0f};
  return rive::make_rcp<Gradient>(Gradient::Kind::radial,
                                  g,
                                  colors,
                                  stops,
                                  count);
}

rive::rcp<rive::RenderPath> Factory::makeRenderPath(rive::RawPath& raw,
                                                    rive::FillRule rule)
{
  return rive::make_rcp<Path>(raw, rule);
}

rive::rcp<rive::RenderPath> Factory::makeEmptyRenderPath()
{
  return rive::make_rcp<Path>();
}

rive::rcp<rive::RenderPaint> Factory::makeRenderPaint()
{
  return rive::make_rcp<Paint>();
}

rive::rcp<rive::RenderImage> Factory::decodeImage(
    rive::Span<const uint8_t> bytes)
{
  plutovg_surface_t* surface = plutovg_surface_load_from_image_data(
      bytes.data(),
      static_cast<int>(bytes.size()));
  if (surface == nullptr)
  {
    return nullptr;
  }
  return rive::make_rcp<Image>(surface);
}

// ---- Renderer ----

Renderer::Renderer(plutovg_canvas_t* canvas) :
    m_canvas(canvas),
    m_width(static_cast<float>(
        plutovg_surface_get_width(plutovg_canvas_get_surface(canvas)))),
    m_height(static_cast<float>(
        plutovg_surface_get_height(plutovg_canvas_get_surface(canvas))))
{}

void Renderer::save() { plutovg_canvas_save(m_canvas); }

void Renderer::restore() { plutovg_canvas_restore(m_canvas); }

void Renderer::transform(const rive::Mat2D& transform)
{
  plutovg_matrix_t m = toVg(transform);
  plutovg_canvas_transform(m_canvas, &m);
}

void Renderer::drawPath(rive::RenderPath* renderPath,
                        rive::RenderPaint* renderPaint)
{
  auto* path = static_cast<Path*>(renderPath);
  auto* paint = static_cast<Paint*>(renderPaint);
  // Nothing to see: fully transparent (particles faded out still get drawn).
  if (paint->maxAlpha() * plutovg_canvas_get_opacity(m_canvas) < 0.5f / 255.0f)
  {
    drawCost().skipped++;
    return;
  }
  const uint32_t t0 = micros();
  const plutovg_path_t* vg = path->vg();
  drawCost().pathMicros += micros() - t0;
  plutovg_rect_t extents;
  plutovg_path_extents(vg, &extents, false);
  // A fill with no area covers nothing (particles shrink to a point).
  if (!paint->isStroke() && (extents.w <= 0.0f || extents.h <= 0.0f))
  {
    drawCost().skipped++;
    return;
  }
  // A mitred corner can reach the miter limit (4) times half the width.
  const float outset = paint->isStroke() ? 2.0f * paint->strokeThickness() : 0.0f;
  plutovg_rect_t device;
  if (!onSurface(extents, outset, &device))
  {
    drawCost().skipped++;
    return;
  }
  if (m_onlyBlackSoFar)
  {
    if (paint->isSolidBlack())
    {
      drawCost().skipped++;
      return;
    }
    m_onlyBlackSoFar = false;
  }
  const uint32_t t1 = micros();
  paint->apply(m_canvas);
  noteDrawn(extents, outset);
#ifdef RIVE_PLUTOVG_TRACE
  {
    plutovg_rect_t device;
    plutovg_canvas_map_rect(m_canvas, &extents, &device);
    plutovg_color_t color;
    plutovg_canvas_get_paint(m_canvas, &color);
    std::printf("draw %s %6.0f %6.0f %6.0f %6.0f rgba %.2f %.2f %.2f %.2f opacity %.2f\n",
                paint->isStroke() ? "stroke" : "fill  ",
                device.x, device.y, device.w, device.h,
                color.r, color.g, color.b, color.a,
                plutovg_canvas_get_opacity(m_canvas));
  }
#endif
  if (paint->isStroke())
  {
    plutovg_canvas_stroke_path(m_canvas, vg);
  }
  else
  {
    plutovg_canvas_set_fill_rule(m_canvas, toVg(path->rule()));
    plutovg_canvas_fill_path(m_canvas, vg);
  }
  const uint32_t spent = micros() - t1;
  drawCost().draws++;
  drawCost().rasterMicros += spent;
  if (paint->isStroke())
  {
    drawCost().strokes++;
    drawCost().strokeMicros += spent;
  }
}

void Renderer::clipPath(rive::RenderPath* renderPath)
{
  auto* path = static_cast<Path*>(renderPath);
  plutovg_canvas_set_fill_rule(m_canvas, toVg(path->rule()));
  plutovg_canvas_clip_path(m_canvas, path->vg());
}

void Renderer::drawImage(const rive::RenderImage* renderImage,
                         rive::ImageSampler,
                         rive::BlendMode blend,
                         float opacity)
{
  if (blend != rive::BlendMode::srcOver)
  {
    unsupported().blendMode++;
  }
  auto* image = static_cast<const Image*>(renderImage);
  m_onlyBlackSoFar = false;
  noteDrawn(plutovg_rect_t{0,
                           0,
                           static_cast<float>(image->width()),
                           static_cast<float>(image->height())},
            0.0f);
  plutovg_canvas_set_texture(m_canvas,
                             image->surface(),
                             PLUTOVG_TEXTURE_TYPE_PLAIN,
                             opacity,
                             nullptr);
  plutovg_canvas_fill_rect(m_canvas,
                           0,
                           0,
                           static_cast<float>(image->width()),
                           static_cast<float>(image->height()));
}

void Renderer::drawImageMesh(const rive::RenderImage*,
                             rive::ImageSampler,
                             rive::rcp<rive::RenderBuffer>,
                             rive::rcp<rive::RenderBuffer>,
                             rive::rcp<rive::RenderBuffer>,
                             uint32_t,
                             uint32_t,
                             rive::BlendMode,
                             float)
{
  unsupported().imageMesh++;
}

bool Renderer::onSurface(plutovg_rect_t local,
                         float outset,
                         plutovg_rect_t* device) const
{
  local.x -= outset;
  local.y -= outset;
  local.w += 2 * outset;
  local.h += 2 * outset;
  plutovg_canvas_map_rect(m_canvas, &local, device);
  return device->x + device->w >= -1 && device->y + device->h >= -1 &&
         device->x <= m_width + 1 && device->y <= m_height + 1;
}

void Renderer::noteDrawn(plutovg_rect_t local, float outset)
{
  local.x -= outset;
  local.y -= outset;
  local.w += 2 * outset;
  local.h += 2 * outset;
  plutovg_rect_t device;
  plutovg_canvas_map_rect(m_canvas, &local, &device);
  // One pixel of antialiasing on every side.
  const float box[4] = {device.x - 1,
                        device.y - 1,
                        device.x + device.w + 1,
                        device.y + device.h + 1};
  if (!m_anyDrawn)
  {
    std::copy(box, box + 4, m_drawn);
    m_anyDrawn = true;
    return;
  }
  m_drawn[0] = std::min(m_drawn[0], box[0]);
  m_drawn[1] = std::min(m_drawn[1], box[1]);
  m_drawn[2] = std::max(m_drawn[2], box[2]);
  m_drawn[3] = std::max(m_drawn[3], box[3]);
}

bool Renderer::drawn(float box[4]) const
{
  if (!m_anyDrawn)
  {
    return false;
  }
  std::copy(m_drawn, m_drawn + 4, box);
  return true;
}

void Renderer::modulateOpacity(float opacity)
{
  plutovg_canvas_set_opacity(m_canvas,
                             plutovg_canvas_get_opacity(m_canvas) * opacity);
}

} // namespace rive_plutovg
