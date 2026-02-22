class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b8/f3/3005cbe63db313a572c6094611da51be38e1354a4b039d089ad22820e5ee/chardet-6.0.0.tar.gz"
  sha256 "aaa00ede13dd39a582de2b1254221a1f3e1c77e7738036431b6cb7e6a05b4f19"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05bdf68f4c1f53997c096ba9290a6dce109ba23006dffe8d5e2afb9ffd7b78f7"
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
