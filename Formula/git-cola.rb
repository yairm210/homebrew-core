class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/68/6a/0f5d026dcbfce99e47c8717500149d110feeba5b02cb0d5db9e5fc3970ea/git-cola-4.1.0.tar.gz"
  sha256 "d77ba2eb1d1240f47cc44f5fcb9230cc65681834e7e27edf17c5ada462d3fb07"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be33c2804e41494f5f138a0a6ba528f51b1e597226003cd25440dca2bb6a77f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd520fe708b90899482b8746c4c5a19d3c8141b525b1dfe8a0a0de2850bee5ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bec10a125052eb152a37853cd7548d0a52c983ecec932b59464e64ce3694ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "647d15251c2a01aad758d19ebbbee1314c94444b7b25963d0e48e1d42c35a897"
    sha256 cellar: :any_skip_relocation, monterey:       "77c4fb575431ac4ec7fcb791e4352d0bd82360fd8f1729eba9cfc9c637cd07af"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7d49d35fbca0bb27fe5626e33dd8d0ed552cd59f0dbc095410366e8b11b1421"
    sha256 cellar: :any_skip_relocation, catalina:       "4b5628b5445fbad117d7e14b7e4501d8f578154747c404f76e964d3411d3b6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58f6c46adbe4f18e10437795f156115a87ae6240c04123e2dcf5db0f49f8e3ed"
  end

  depends_on "pyqt@5"
  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "QtPy" do
    url "https://files.pythonhosted.org/packages/b0/96/4f3be023cee0261b1f6cd5d2f6c2a5abea8d8022fc66027da8792373a57e/QtPy-2.3.0.tar.gz"
    sha256 "0603c9c83ccc035a4717a12908bf6bc6cb22509827ea2ec0e94c2da7c9ed57c5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
