class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  license "MIT"
  head "https://github.com/sstadick/perbase.git", branch: "master"

  stable do
    url "https://github.com/sstadick/perbase/archive/refs/tags/v1.4.0.tar.gz"
    sha256 "fc0d08964950381969a1cf12e1e1e39eb8edde26794b8d653e7d80b08180fc43"

    uses_from_macos "xz" => :build
    uses_from_macos "curl"
    uses_from_macos "zlib"

    # Resource to avoid building bundled curl, xz and zlib-ng
    # Issue ref: https://github.com/rust-bio/hts-sys/issues/23
    resource "hts-sys" do
      url "https://static.crates.io/crates/hts-sys/hts-sys-2.2.0.crate"
      sha256 "e38d7f1c121cd22aa214cb4dadd4277dc5447391eac518b899b29ba6356fbbb2"

      livecheck do
        url "https://raw.githubusercontent.com/sstadick/perbase/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
        regex(/name = "hts-sys"\nversion = "(\d+(?:\.\d+)+)"/i)
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "deddd7047c55fc5702e2ecebfbf3136e765564d7f838e64eef478b3415eb1e9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6233aa484e304a47225050410eae24bdcd1ebfddf5bb3a5ef1aba6facae788b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96f3a0161aa1648b79b3b4a1ff3b53d02ddb4577df7966fb83b16041106ccf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "57d6363625d631e6caea7bc222eb8087d6c6fc4de89e08dfc57e92b398da30d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cb3f11561cd0cedfc9f826ae1fcff2ca82a5a989846768ff43345ee61e6f9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97596e7432df87b62a4224c2fc435ff0f6cf1eb76c547f5b72d56b7d54c45888"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bamtools" => :test

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for `libclang`

  on_linux do
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib if OS.linux?

    if build.stable?
      # TODO: remove this check when bump-formula-pr can automatically update resources
      hts_sys_version = File.read("Cargo.lock")[/name = "hts-sys"\nversion = "(\d+(?:\.\d+)+)"/i, 1]
      odie "Resource `hts-sys` version needs to be updated!" if resource("hts-sys").version != hts_sys_version

      # Workaround to disable building bundled zlib-ng in "gzp -> flate2"
      inreplace "Cargo.toml",
                /^(gzp = )("[\d.]+")$/,
                '\1{ version = \2, default-features = false, features = ["deflate_zlib", "libdeflate"] }'

      # Workaround to disable building bundled curl, xz and zlib-ng in "rust-htslib -> hts-sys"
      resource("hts-sys").stage(buildpath/"hts-sys")
      inreplace "hts-sys/Cargo.toml" do |s|
        s.gsub!(/^features = \[\s*"static-curl",\s*"static-ssl",/, "features = [")
        s.gsub!(/^features = \[\s*"static"\s*\]$/, "")
        s.gsub!(/^features = \[\s*"zlib-ng",\s*"static",\s*\]$/, "")
      end
      args = %w[--config patch.crates-io.hts-sys.path="hts-sys"]
    end

    system "cargo", "install", *args, *std_cargo_args
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/test.bam", testpath
    system Formula["bamtools"].opt_bin/"bamtools", "index", "-in", "test.bam"
    system bin/"perbase", "base-depth", "test.bam", "-o", "output.tsv"
    assert_path_exists "output.tsv"
  end
end
