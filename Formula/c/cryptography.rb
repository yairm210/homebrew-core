class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/60/04/ee2a9e8542e4fa2773b81771ff8349ff19cdd56b7258a0cc442639052edb/cryptography-46.0.5.tar.gz"
  sha256 "abace499247268e3757271b2f1e244b36b06f8515cf27c4d49468fc9eb16e93d"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92d8aa87b7e06827b7005d249aab7b477062ddc5e24be66aa8c870982e996e01"
    sha256 cellar: :any,                 arm64_sequoia: "18cc3e671fe4e153482b22cb03116b755d2efe0bb6a6bb7a106e52a5c5f4345a"
    sha256 cellar: :any,                 arm64_sonoma:  "f2940989b507edf85572600e7e33fc6aa105d6b6ab264e78d45fca89552847ee"
    sha256 cellar: :any,                 sonoma:        "70c65e0b942f4e138d75f932a27ce23fa546a73b380ccd36d6b096faebb89bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec09ba9ca83dc8a31c4eb6799091814fcddcdb4945d8ffdba2a21a9bf95338d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5458396be9cf189441d8d310906428f4f7c63cde3c6e214c4e5091239959fbe3"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  pypi_packages exclude_packages: ["cffi", "pycparser"]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # TODO: Avoid building multiple times as binaries are already built in limited API mode
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    PYTHON

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end
