class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.81.8.tar.gz"
  sha256 "32020d5de41f71dc510435930542f405144a6fe9bf8c909ffd19a714bb7c7d9b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e290a91fa1c3002d10267d2760c219491af51968790e57d4c80ff0a083750bd3"
    sha256 cellar: :any,                 arm64_sequoia: "833a0314fb5bfec1e13e6ead9cbcba936fb23e8b5a6ecc1c7c4e94bc1ce7e9a0"
    sha256 cellar: :any,                 arm64_sonoma:  "0203aa7b748d4661bc9080702840a17b0c5db006f749a7d6fe8447cbacc90fbf"
    sha256 cellar: :any,                 sonoma:        "90167dda1705dc5c4b3d5f84232d00bc65066b0f93d23ba8494b44d8fc7f851a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba2d3b4c018e4d18f97ee00c1115e99e704b6a7a0e1cbe877a945d3e690aaa67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b67d8367232c92091ceac67a51b28f8cc8f64535687df4316f1e84affbb84872"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
