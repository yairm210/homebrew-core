class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.29.0.tar.xz"
  sha256 "248bc76141f2b8b006ccba9e0bb2cb46cbcb1be4181a1cf2728187f778853654"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "f96de6b0a5b4fed1d76a77c788934b5193bab9e6c8c01bff18457704d1349acf"
    sha256 arm64_tahoe:       "7edd1f9d16c5beeefd1ed0c2c35c26ea99e25a35a59770ae29bcd7708aa7c70e"
    sha256 arm64_sequoia:     "cf4a1b17006786fd7b48c8114d484cc46950cc0b756ed3f0503a1fa9345880e5"
    sha256 arm64_linux:       "97c66e9bd234f504b85d5481d06e40ed572427938a7933e7bf65062c16a29b31"
    sha256 x86_64_linux:      "5c2491ce7dccbf77b55884c6fe33d28d7bbefb0296eb17391b11eb8cc88d2891"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "bullet"
  depends_on "cairo"
  depends_on "dbus"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "luajit"
  depends_on "lz4"
  depends_on "openjpeg"
  depends_on "openssl@4"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  # Fix build on macOS where OpenGL headers lack `glGetShaderPrecisionFormat`
  patch :DATA

  def install
    args = %w[
      -Davahi=false
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dembedded-lz4=false
      -Deeze=false
      -Dglib=true
      -Dinput=false
      -Dlibmount=false
      -Dopengl=full
      -Dphysics=true
      -Dpipewire=false
      -Dsystemd=false
      -Dv4l2=false
      -Dx11=false
      -Dlua-interpreter=luajit
    ]
    args << "-Dcocoa=true" if OS.mac?

    # Install in our Cellar - not dbus's
    inreplace "dbus-services/meson.build", "dep.get_variable(pkgconfig : 'session_bus_services_dir')",
                                           "'#{share}/dbus-1/services'"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    update_mime_database
  end

  test do
    system bin/"edje_cc", "-V"
    system bin/"eet", "-V"
  end
end
__END__
--- a/src/modules/evas/engines/gl_generic/evas_ector_gl_span_shader.c
+++ b/src/modules/evas/engines/gl_generic/evas_ector_gl_span_shader.c
@@ -291,8 +291,14 @@ _span_fragment_highp_supported(void)
 
    if (_span_fs_highp >= 0) return _span_fs_highp;
 
+#ifdef GL_HIGH_FLOAT
    glGetShaderPrecisionFormat(GL_FRAGMENT_SHADER, GL_HIGH_FLOAT,
                               range, &precision);
+#else
+   // macOS's legacy GL headers lack the ES2 precision query, and desktop GL
+   // always supports fragment highp.
+   range[0] = range[1] = precision = 1;
+#endif
    _span_fs_highp = ((range[0] != 0) || (range[1] != 0) || (precision != 0)) ? 1 : 0;
    if (!_span_fs_highp)
      INF("span shader: fragment highp unsupported, falling back to mediump");
