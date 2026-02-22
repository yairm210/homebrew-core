class Pyperformance < Formula
  include Language::Python::Virtualenv

  desc "Python benchmark suite"
  homepage "https://github.com/python/pyperformance"
  url "https://files.pythonhosted.org/packages/9e/bc/ebc48f2af24abe0d13681ac7ccb21c3f0ed0128361522f5904d4f21953e9/pyperformance-1.14.0.tar.gz"
  sha256 "91f74393997b604375ad5b79bf569a24076d70181c076a53abad5383a238a8aa"
  license "MIT"
  head "https://github.com/python/pyperformance.git", branch: "main"

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pyperf" do
    url "https://files.pythonhosted.org/packages/89/f9/27bd50fb5475147ad04e288a076f29a893c1e94f10866fc3623a84ad75d2/pyperf-2.9.0.tar.gz"
    sha256 "dbe0feef8ec1a465df191bba2576149762d15a8c9985c9fea93ab625d875c362"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    list_output = shell_output("#{bin}/pyperformance list --benchmarks nbody")
    assert_match "'nbody' benchmarks:", list_output
    assert_match "- nbody", list_output

    groups_output = shell_output("#{bin}/pyperformance list_groups")
    assert_match "tags:", groups_output
  end
end
