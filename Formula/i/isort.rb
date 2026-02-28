class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/ef/7c/ec4ab396d31b3b395e2e999c8f46dec78c5e29209fac49d1f4dace04041d/isort-8.0.1.tar.gz"
  sha256 "171ac4ff559cdc060bcfff550bc8404a486fee0caab245679c2abe7cb253c78d"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "483a7f4b431a18722636c1249e5dff74918877708d52d713a41c15bd1fd033fc"
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
