class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.21.8.tar.gz"
  sha256 "fb83f29fa12622a72cc56de97f7b8c27a2d3081ab9174062761bb84ed00e367a"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "599477bb2c3297f135a907339845fbb28959fa43c255be6113fc5dd90180f6e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af3be75a9fa39f7b84599d28251b187250f502f7a5d3d1d6c2e7fdd4e3db0644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6a7cdbb4ee0d72313adeb7c6e5ebe04b96e5c1aa7852cb1ef7334920cf4dae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e796a8fd99e0567b3615f3738fb5c529968ebcb5fc41980bf7e42bff624f133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e57a7ac3be0c7557dada080f2dd7fab1c67ed5b80f0a1b5845b8e7d5cbe5d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e67814f17a6482aaa04e381fdb26345c9d248e75b3e965d3cb3df93303f5048"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
