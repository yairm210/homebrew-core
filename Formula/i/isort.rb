class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/bf/e3/e72b0b3a85f24cf5fc2cd8e92b996592798f896024c5cdf3709232e6e377/isort-8.0.0.tar.gz"
  sha256 "fddea59202f231e170e52e71e3510b99c373b6e571b55d9c7b31b679c0fed47c"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8a1f07df8891c8812977c1469578923a4129f2afaa12a9533fcd2f585a1fe1d"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~PYTHON
      from third_party import lib
      import os
    PYTHON
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
