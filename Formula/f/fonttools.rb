class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/d4/41/0f072a712dc74496e03710e462a18a4cfd8a258ad055a4e22d28b43a7abd/fonttools-4.64.0.tar.gz"
  sha256 "ecb2e59a7bc692fee64dda6010deb66222335693b30046f15cccf81233aa715f"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b83eb1c97d1be6c8c6b61ef7995afd28f402fd561441b2d978151de4dbd5c72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c4c66583ca2e33b3b43c4a44426daec33c5a54c250df504cea554e08eba7b22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dd2258e97432fbd01cf9c80ff985f3956464aa6af3fd454b472041ec7eb8e5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbe51c0da859125372b1773ffc2d6afd2514e2db32ccee5a98339c4232ab6112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "803a7bd4b8bfb9f24266e52f8122df3bcd96c716e31b96f7d50c460e69b7dbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d248065b21d07f803743e7c46ff2399c62ef3bf7d387e2661c515c29dd4a41d7"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ad/a9/970b8fa0ecc4fbf1dfaed0d89bbc1fc1421b25ec26a2038c91e872dc6c8e/lxml-6.1.2.tar.gz"
    sha256 "1055241852f2b02068af4a625a5d32c087db193c12251928af2562ecd2239f18"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/74/21/3b6af43a663b22b00e738bb0642931a2579e15da6852613d56c6aa535d28/zopfli-0.4.3.tar.gz"
    sha256 "d3a50f91a13cea9bafe025de8fd87a005eb26de02a4f0c193127ddbf23ac8ebe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
