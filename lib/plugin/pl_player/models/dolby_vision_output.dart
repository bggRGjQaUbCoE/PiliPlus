enum DolbyVisionOutput {
  mpv('mpv（原播放器）'),
  surface('Media3 · SurfaceView（新合成）'),
  texture('Media3 · Flutter 纹理（测试）');

  const DolbyVisionOutput(this.label);
  final String label;
}
