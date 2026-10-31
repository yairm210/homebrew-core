class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "b4d8a5360b87ecce3f5ce4ccbd78f2765bc20915ac703c65f4339c58dc585197"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9af4858356326dbaa195aea7e99eefe620e0d1e804fd449355229704643ce8a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db2687582781706fc75f831d1811cc38db7f10cfdcdbf289c5719fc683a24409"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1ae26f9e55b982c98a67372704883a257755de7a238d74d312e39edd93ada09"
    sha256 cellar: :any,                 arm64_linux:       "6063a3aaf4044e30ada0926b32f9463b487edf06139141f7029057effc195b4c"
    sha256 cellar: :any,                 x86_64_linux:      "d921069ebf095044b7141fcb5f6be793ce1517c81b08f0d905c5879d0305c139"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `test do` block downloads fonts.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end
