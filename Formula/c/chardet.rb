class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b8/f3/3005cbe63db313a572c6094611da51be38e1354a4b039d089ad22820e5ee/chardet-6.0.0.tar.gz"
  sha256 "aaa00ede13dd39a582de2b1254221a1f3e1c77e7738036431b6cb7e6a05b4f19"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "3c508a057b1c86120b7985200af556d301600d3352727e6a91b5118acaea2474"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence 0.7525", output
  end
end
