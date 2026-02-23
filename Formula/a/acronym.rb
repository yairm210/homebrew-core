class Acronym < Formula
  include Language::Python::Virtualenv

  desc "Python-based tool for creating English-ish acronyms from your fancy project"
  homepage "https://github.com/bacook17/acronym"
  url "https://files.pythonhosted.org/packages/e3/1a/1a364f93053f9ad0d4f38b5c0078637db484bb4c1388ad0234b85c9d2ca8/acronym-2.0.0.tar.gz"
  sha256 "163cc1630b7c65cbca6426f80e267f5253ea787e17a329d1d55517868897bbf1"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28f9d722ad4f7ca4cac9b84faf09f19536bebc7e4fe17887cc1666eac6281f47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f0bf7427caeeb3f33476658bd69bbfebd547df49c90db6a328ebabbbf7b7a78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "527bcd0322a0b731e280b2f75905a19bccd0e14490123f6f3b57709105eb993d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a745d5f44b5fb3d34c850e7d391a19c1e938631cf381b10c5374ae8b29524d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bfabc3eda08a2f8f3c38ccba43b2cc1d34be7cd0ac0880485f5dcc8c6944ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6056bea3ce25ae1105f1de1129a5ca5bbaf133ee2151fd94c841a81062a6fdb5"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "numpy"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: "numpy"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/41/f2/d34e8b3a08a9cc79a50b2208a93dce981fe615b64d5a4d4abee421d898df/joblib-1.5.3.tar.gz"
    sha256 "8561a3269e6801106863fd0d6d84bb737be9e7631e33aaed3fb9ce5953688da3"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/f9/76/3a5e4312c19a028770f86fd7c058cf9f4ec4321c6cf7526bab998a5b683c/nltk-3.9.2.tar.gz"
    sha256 "0f409e9b069ca4177c1903c3e843eef90c7e92992fa4931ae607da6de49e1419"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/2e/0c/b28ed414f080ee0ad153f848586d61d1878f91689950f037f976ce15f6c8/pandas-3.0.1.tar.gz"
    sha256 "4186a699674af418f655dbd420ed87f50d56b4cd6603784279d9eef6627823c8"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/ff/c0/d8079d4f6342e4cec5c3e7d7415b5cd3e633d5f4124f7a4626908dbe84c7/regex-2026.2.19.tar.gz"
    sha256 "6fb8cb09b10e38f3ae17cc6dc04a1df77762bd0351b6ba9041438e7cc85ec310"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "TEMPORAL", shell_output("#{bin}/acronym 'The missing package manager for macOS (or Linux)'")
  end
end
