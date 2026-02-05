class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 14

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d18128d5c2340262665bf5d63cfdad60c9123c35263bc6386f8547f50d280232"
    sha256 cellar: :any,                 arm64_sequoia: "9699a0ea3a717a84f14121a83a87a7dadcb750efdf6b53113f12b071195062cd"
    sha256 cellar: :any,                 arm64_sonoma:  "c98ed0c1d16634ccedb273de756405518ed19b215ffc270d6f439d7c2ed3c1d0"
    sha256 cellar: :any,                 sonoma:        "2c37aeccd305f0c70f00c146cc590cc700244ffa5309f5f673320154d3e37dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "359690bc3c79939b2e520fd2dec9e00b2c7775df038d6b24ea81d28bf1cb4362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "279b8bb50240191f28390ed15f4c081dad8e7e851ea442697681e5b32fb9aaf0"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  # Backport fix for `poppler` 25+ compatibility
  # PR ref: https://github.com/otfried/ipe-tools/pull/72
  # PR ref: https://github.com/otfried/ipe-tools/pull/77
  patch do
    url "https://github.com/otfried/ipe-tools/commit/0da954e50fbdedf43796291853890fe36248bc16.patch?full_index=1"
    sha256 "65f7010897fa4dd94cfa933d986cae6978ddd4e33e2aa1479ec7c11786e100c3"
  end
  patch do
    url "https://github.com/otfried/ipe-tools/commit/2f59d3b747a23cd4b13b09ebee9f703b8129116c.patch?full_index=1"
    sha256 "b1b48088c9dd4067d862d788643c750fc6981102cd85f62a85f898948ca33771"
  end

  # Backport fix for poppler 26.02+ compatibility
  # Upstream PR ref: https://github.com/otfried/ipe-tools/pull/79
  patch :DATA

  def install
    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end

__END__
diff --git a/pdftoipe/xmloutputdev.cpp b/pdftoipe/xmloutputdev.cpp
index 506b16d..bb0b37d 100644
--- a/pdftoipe/xmloutputdev.cpp
+++ b/pdftoipe/xmloutputdev.cpp
@@ -290,21 +290,28 @@ void XmlOutputDev::startText(GfxState *state, double x, double y)
   double xt, yt;
   state->transform(x, y, &xt, &yt);
 
-  const double *T = state->getTextMat();
-  const double *C = state->getCTM();
+#if POPPLER_VERSION_AT_LEAST(26, 2, 0)
+  const auto &T = state->getTextMat();
+  const auto &C = state->getCTM();
+  const double *Tp = T.data();
+  const double *Cp = C.data();
+#else
+  const double *Tp = state->getTextMat();
+  const double *Cp = state->getCTM();
+#endif
 
   /*
   fprintf(stderr, "TextMatrix = %g %g %g %g %g %g\n", 
-	  T[0], T[1], T[2], T[3], T[4], T[5]);
+	  Tp[0], Tp[1], Tp[2], Tp[3], Tp[4], Tp[5]);
   fprintf(stderr, "CTM = %g %g %g %g %g %g\n", 
-	  C[0], C[1], C[2], C[3], C[4], C[5]);
+	  Cp[0], Cp[1], Cp[2], Cp[3], Cp[4], Cp[5]);
   */
 
   double M[4];
-  M[0] = C[0] * T[0] + C[2] * T[1];
-  M[1] = C[1] * T[0] + C[3] * T[1];
-  M[2] = C[0] * T[2] + C[2] * T[3];
-  M[3] = C[1] * T[2] + C[3] * T[3];
+  M[0] = Cp[0] * Tp[0] + Cp[2] * Tp[1];
+  M[1] = Cp[1] * Tp[0] + Cp[3] * Tp[1];
+  M[2] = Cp[0] * Tp[2] + Cp[2] * Tp[3];
+  M[3] = Cp[1] * Tp[2] + Cp[3] * Tp[3];
 
  GfxRGB rgb;
  state->getFillRGB(&rgb);
@@ -348,7 +355,12 @@ void XmlOutputDev::drawImage(GfxState *state, Object *ref, Stream *str,
 
   writePSFmt("<image width=\"%d\" height=\"%d\"", width, height);
 
+#if POPPLER_VERSION_AT_LEAST(26, 2, 0)
+  const auto &matArr = state->getCTM();
+  const double *mat = matArr.data();
+#else
   const double *mat = state->getCTM();
+#endif
   double tx = mat[0] + mat[2] + mat[4];
   double ty = mat[1] + mat[3] + mat[5];
   writePSFmt(" rect=\"%g %g %g %g\"", mat[4], mat[5], tx, ty);
