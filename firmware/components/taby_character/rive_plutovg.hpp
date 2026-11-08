// Rive's Factory and Renderer drawn by PlutoVG, a small CPU vector rasterizer.
//
// The Rive runtime never touches pixels: it asks a Factory for paths, paints
// and shaders, and replays an artboard through a Renderer (save/restore,
// transform, clip, drawPath). This maps that interface onto PlutoVG so the
// same runtime runs on a microcontroller without a GPU.
//
// Not drawn: feathering, blend modes other than source-over, and image
// meshes. Each is counted so a file that leans on them can be spotted.
#pragma once

#include "plutovg.h"
#include "rive/factory.hpp"
#include "rive/math/raw_path.hpp"
#include "rive/renderer.hpp"

#include <chrono>
#include <cstdint>
#include <vector>

namespace rive_plutovg
{

struct Unsupported
{
  uint32_t feather = 0;
  uint32_t blendMode = 0;
  uint32_t imageMesh = 0;
  uint32_t clockwiseFill = 0;
};

Unsupported& unsupported();

class Path : public rive::RenderPath
{
public:
  Path() = default;
  Path(rive::RawPath& rawPath, rive::FillRule fillRule);
  ~Path() override;

  void rewind() override;
  void fillRule(rive::FillRule value) override { m_fillRule = value; }
  void addRenderPath(const rive::RenderPath* path,
                     const rive::Mat2D& transform) override;
  void moveTo(float x, float y) override;
  void lineTo(float x, float y) override;
  void cubicTo(float ox, float oy, float ix, float iy, float x, float y)
      override;
  void close() override;
  void addRawPath(const rive::RawPath& path) override;

  const rive::RawPath& raw() const { return m_raw; }
  rive::FillRule rule() const { return m_fillRule; }
  /// The PlutoVG copy, rebuilt only after the path changed.
  const plutovg_path_t* vg() const;

private:
  rive::RawPath m_raw;
  rive::FillRule m_fillRule = rive::FillRule::nonZero;
  mutable plutovg_path_t* m_vg = nullptr;
  mutable bool m_dirty = true;
};

class Gradient : public rive::RenderShader
{
public:
  enum class Kind
  {
    linear,
    radial
  };
  Gradient(Kind kind,
           const float geometry[4],
           const rive::ColorInt colors[],
           const float stops[],
           size_t count);

  Kind kind;
  float geometry[4]; // linear: sx sy ex ey; radial: cx cy r -
  std::vector<plutovg_gradient_stop_t> stops;
};

class Paint : public rive::RenderPaint
{
public:
  void style(rive::RenderPaintStyle value) override { m_style = value; }
  void color(rive::ColorInt value) override { m_color = value; }
  void thickness(float value) override { m_thickness = value; }
  void join(rive::StrokeJoin value) override { m_join = value; }
  void cap(rive::StrokeCap value) override { m_cap = value; }
  void feather(float value) override;
  void blendMode(rive::BlendMode value) override { m_blend = value; }
  void shader(rive::rcp<rive::RenderShader> value) override
  {
    m_shader = std::move(value);
  }
  void shaderTransform(const rive::Mat2D& transform) override
  {
    m_shaderTransform = transform;
  }
  void invalidateStroke() override {}

  /// Puts this paint on the canvas for the next fill or stroke.
  void apply(plutovg_canvas_t* canvas) const;
  bool isStroke() const { return m_style == rive::RenderPaintStyle::stroke; }
  float strokeThickness() const { return m_thickness; }
  /// The most opaque this paint can be, 0..1, before the canvas opacity.
  float maxAlpha() const;
  /// A plain colour with no red, green or blue: it can only darken.
  bool isSolidBlack() const
  {
    return m_shader == nullptr && (m_color & 0x00FFFFFF) == 0;
  }

private:
  rive::RenderPaintStyle m_style = rive::RenderPaintStyle::fill;
  rive::ColorInt m_color = 0xFF000000;
  float m_thickness = 1.0f;
  rive::StrokeJoin m_join = rive::StrokeJoin::miter;
  rive::StrokeCap m_cap = rive::StrokeCap::butt;
  rive::BlendMode m_blend = rive::BlendMode::srcOver;
  rive::rcp<rive::RenderShader> m_shader;
  rive::Mat2D m_shaderTransform;
};

class Image : public rive::RenderImage
{
public:
  explicit Image(plutovg_surface_t* surface);
  ~Image() override;
  plutovg_surface_t* surface() const { return m_surface; }

private:
  plutovg_surface_t* m_surface;
};

class Buffer : public rive::RenderBuffer
{
public:
  Buffer(rive::RenderBufferType type,
         rive::RenderBufferFlags flags,
         size_t sizeInBytes);

protected:
  void* onMap() override { return m_bytes.data(); }
  void onUnmap() override {}

private:
  std::vector<uint8_t> m_bytes;
};

class Factory : public rive::Factory
{
public:
  rive::rcp<rive::RenderBuffer> makeRenderBuffer(rive::RenderBufferType,
                                                 rive::RenderBufferFlags,
                                                 size_t) override;
  rive::rcp<rive::RenderShader> makeLinearGradient(float sx,
                                                   float sy,
                                                   float ex,
                                                   float ey,
                                                   const rive::ColorInt[],
                                                   const float[],
                                                   size_t) override;
  rive::rcp<rive::RenderShader> makeRadialGradient(float cx,
                                                   float cy,
                                                   float radius,
                                                   const rive::ColorInt[],
                                                   const float[],
                                                   size_t) override;
  rive::rcp<rive::RenderPath> makeRenderPath(rive::RawPath&,
                                             rive::FillRule) override;
  rive::rcp<rive::RenderPath> makeEmptyRenderPath() override;
  rive::rcp<rive::RenderPaint> makeRenderPaint() override;
  rive::rcp<rive::RenderImage> decodeImage(
      rive::Span<const uint8_t>) override;
};

/** Where drawing time went since the last reset (for profiling). */
struct DrawCost
{
  uint32_t draws = 0;    // reached PlutoVG
  uint32_t skipped = 0;  // transparent, off-screen or black-on-black
  uint32_t pathMicros = 0;   // RawPath to PlutoVG path conversions
  uint32_t rasterMicros = 0; // PlutoVG fill and stroke
  uint32_t strokes = 0;
  uint32_t strokeMicros = 0; // the stroke part of rasterMicros
};
DrawCost& drawCost();

class Renderer : public rive::Renderer
{
public:
  explicit Renderer(plutovg_canvas_t* canvas);

  void save() override;
  void restore() override;
  void transform(const rive::Mat2D& transform) override;
  void drawPath(rive::RenderPath* path, rive::RenderPaint* paint) override;
  void clipPath(rive::RenderPath* path) override;
  void drawImage(const rive::RenderImage*,
                 rive::ImageSampler,
                 rive::BlendMode,
                 float opacity) override;
  void drawImageMesh(const rive::RenderImage*,
                     rive::ImageSampler,
                     rive::rcp<rive::RenderBuffer>,
                     rive::rcp<rive::RenderBuffer>,
                     rive::rcp<rive::RenderBuffer>,
                     uint32_t,
                     uint32_t,
                     rive::BlendMode,
                     float) override;
  void modulateOpacity(float opacity) override;

  /// Starts a frame on a canvas cleared to black: forgets what was drawn,
  /// and skips black draws until something else has been drawn (an opaque
  /// black background on black changes nothing).
  void resetDrawn()
  {
    m_anyDrawn = false;
    m_onlyBlackSoFar = true;
  }
  /// The device-space box (x0, y0, x1, y1) all draws since resetDrawn()
  /// can have touched. False if nothing was drawn.
  bool drawn(float box[4]) const;

private:
  void noteDrawn(plutovg_rect_t local, float outset);
  /// Maps a local box to the device; false if it misses the surface.
  bool onSurface(plutovg_rect_t local, float outset, plutovg_rect_t* device) const;

  plutovg_canvas_t* m_canvas;
  float m_width;
  float m_height;
  bool m_anyDrawn = false;
  bool m_onlyBlackSoFar = false;
  float m_drawn[4] = {0, 0, 0, 0};
};

} // namespace rive_plutovg
