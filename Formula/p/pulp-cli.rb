class PulpCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Pulp 3"
  homepage "https://github.com/pulp/pulp-cli"
  url "https://files.pythonhosted.org/packages/70/73/20367ec1f4a74e27010788856ca206c18747023047b080d98c002c01a328/pulp_cli-0.38.0.tar.gz"
  sha256 "c0a38147ccbaa56843ff58701553dd3c79971326d082ff05287393e40bbc9763"
  license "GPL-2.0-or-later"
  head "https://github.com/pulp/pulp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8eb5e71e496385cbebbeed2bd0a2c72f9fc731fc46013be5678c6c5e8611e162"
    sha256 cellar: :any,                 arm64_sequoia: "b72985f1c8b0644f6b30cad64fb17c25c65b210b4b81870bb798b13bf7dd13fd"
    sha256 cellar: :any,                 arm64_sonoma:  "2193420568448f285e9f1d20b35f7a2cffd7c51b5479bb2d56d667f9cf29e57c"
    sha256 cellar: :any,                 sonoma:        "c034f293bacce13172109a9f6b940ac12ea5966b5e46f6c5b4ab154b4098a46e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15ccac94e857774239778be54de6baa7e84782f28a20887d5f1a2e045e66fe6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf5c2db8bae4e12d2a936425df3a424bb7adf8f53f3e2f3791b88a4fa4ca90f"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pulp-glue" do
    url "https://files.pythonhosted.org/packages/2b/9b/f25bda4795580b8200beac500a30fd88090b299690f6e7f7de35866a0b3c/pulp_glue-0.38.0.tar.gz"
    sha256 "8c8c889bf4934989739c6eb4a327e71bce1c5983dd723b62c3cf053d2c6bbb92"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/fb/2e/8da627b65577a8f130fe9dfa88ce94fcb24b1f8b59e0fc763ee61abef8b8/schema-0.7.8.tar.gz"
    sha256 "e86cc08edd6fe6e2522648f4e47e3a31920a76e82cce8937535422e310862ab5"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pulp", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp --version")

    (testpath/"config.toml").write <<~TEXT
      [cli]
      base_url = "https://pulp.dev"
      verify_ssl = false
      format = "json"
    TEXT

    output = shell_output("#{bin}/pulp config validate --location #{testpath}/config.toml")
    assert_match "valid pulp-cli config", output
  end
end
