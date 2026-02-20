class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v3.1.8.tar.gz"
  sha256 "ab4c83db509065c9e4a3d2ed61280206df41c4efb13d8087a261b2b31873be4b"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "587663fffc9f10da1338bd74511ee9997dab9283353b6f1cc57dc52e5dedca0f"
    sha256 cellar: :any,                 arm64_sonoma:  "dc737b2805e44862c7d71a09646f65646744ae2e720767a3b8b864f8789c1b21"
    sha256 cellar: :any,                 arm64_ventura: "f168f86719af5f2eda08655be0ca639aa8ffa24d666af60f3c350296de8ac7a0"
    sha256 cellar: :any,                 sonoma:        "bf2095088594fdf9c04698c0b274dc4933afecfec472570a09fc05d560048ef1"
    sha256 cellar: :any,                 ventura:       "98ecdf1700ab37071fffef07518908e80168a1b77cda03a66d18880fccb66cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd0f91388df10d9e4f452fa7a13070d2d8cbf0212474ad5074df19fe732bdc01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e327904665e09bb0beb049379e085cdf2c7ecfec1af44fdfd8eb60c664777a5a"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "rocksdb"

  uses_from_macos "bzip2"

  # Backport fixes for newer Rust
  patch do
    url "https://github.com/anza-xyz/agave/commit/4b0384e8d7ffdb13c9e73ebdfdc8a0e1cc8ca290.patch?full_index=1"
    sha256 "ba8ee2f0624fe83fdfb0d198d840a115f546924d345029afda344b5a57c57f9e"
  end
  patch do
    url "https://github.com/anza-xyz/agave/commit/8f3944b2159112b8e017b41f9c834344b32a7c59.patch?full_index=1"
    sha256 "b5c59105fd9fa22f96a5135d3c14a61f63cbd86b31f509a06574965520c11414"
  end

  # Backport disabling LTO to compile with Apple Clang
  patch do
    url "https://github.com/anza-xyz/agave/commit/5e900421520a10933642d5e9a21e191a70f9b125.patch?full_index=1"
    sha256 "5a03a89dfcb91a3b579e1f67a78580f626c6560e8c6a46c371d7297665b22360"
  end

  # Work around Homebrew-specific issue using Apple Clang 1700 (LLVM 19) by updating cc-rs
  # https://github.com/Homebrew/brew/issues/21112
  patch :DATA

  def install
    # Work around until new release as fixed upstream but commits do not cleanly apply
    ENV.append_to_rustflags "--allow unused-imports"

    # Work around librocksdb-sys build failure with Apple libclang, "Library not loaded: @rpath/libclang.dylib"
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s if OS.mac?

    # Use brew dependencies
    ENV["PROTOC"] = Formula["protobuf"].opt_bin/"protoc"
    ENV["ROCKSDB_LIB_DIR"] = Formula["rocksdb"].opt_lib

    bins = %w[
      cli
      faucet
      genesis
      gossip
      keygen
      stake-accounts
      tokens
      validator
      watchtower
    ]
    bins_dcou = %w[
      ledger-tool
    ]
    (bins + bins_dcou).each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    output = shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match "Generating a new keypair", output
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 045adc06b4..5ffbb89f1c 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1720,9 +1720,9 @@ checksum = "37b2a672a2cb129a2e41c10b1224bb368f9f37a2b16b612598138befd7b37eb5"
 
 [[package]]
 name = "cc"
-version = "1.2.16"
+version = "1.2.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "be714c154be609ec7f5dad223a33bf1482fff90472de28f7362806e6d4832b8c"
+checksum = "8691782945451c1c383942c4874dbe63814f61cb57ef773cda2972682b7bb3c0"
 dependencies = [
  "jobserver",
  "libc",
