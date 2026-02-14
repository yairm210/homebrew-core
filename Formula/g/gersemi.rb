class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/42/a9/fe83ed525ef8666a08e681f528b7567f2ae90bfad94cb06aa601577163d4/gersemi-0.26.0.tar.gz"
  sha256 "20853edb20a1d1c77057df8787eb4e17b9d1eb6facac13c47826924ff741fc73"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4a14a304bc6c31f83c293466580c90f6b7ef2d378d817a250a40d89b3eb3388"
    sha256 cellar: :any,                 arm64_sequoia: "e89cc4677ceb0030d3987bee99a988603eefa1148e2e9a6a07cb1b13e029cea0"
    sha256 cellar: :any,                 arm64_sonoma:  "34f8954545512ef8006e0f8084ba565f0527c1ed45d07433d7f5ca8e765a7be1"
    sha256 cellar: :any,                 sonoma:        "156694580a2f961b53aee318a7e577e5c06f01707ccb28a8faae5162f0782b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c518ac2bd8270d607ddce1953aa1ef935c52bdb8054b3423938cf1c63964da0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb775d4be68f6aec722ef31f7496c3c231c657ce77a0e70926432d943e585645"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/86/67/b4c74e93ebacaea2743f98e3195b02a2a9a9be74540b0a75cf8c6fdbac24/ignore_python-0.3.2.tar.gz"
    sha256 "264f17faa6c41f134511f400fae8401b2fee666f1c4e2827a3e02724ea294f8d"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d6/f3/1632085bda21cae242998e27f63d3a2c02cdcdb36cade334fa689f210903/platformdirs-4.9.0.tar.gz"
    sha256 "d8c98e89c427a101947441c7e77b4cd1c8ea717de6f3885e2aa9c73fce276207"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gersemi --version")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    # Return 0 when there's nothing to reformat.
    # Return 1 when some files would be reformatted.
    system bin/"gersemi", "--check", testpath/"CMakeLists.txt"

    system bin/"gersemi", testpath/"CMakeLists.txt"

    expected_content = <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    assert_equal expected_content, (testpath/"CMakeLists.txt").read
  end
end
