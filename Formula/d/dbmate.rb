class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.29.5.tar.gz"
  sha256 "55faf8e2751efa81b4c135a5411012a0cea80a60c29e8c7be6f5e777aa4f3706"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b70147bf595cb6d842bdfe673177f42f86b8e62f59446c82d0f2bfedd7d6c259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "555bdc5d4c797c9f39655eab2d2ffdb098400bb93ff31ef96ec0beb3d37d5edc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96c75b56f48633e770bd5579f99320055710d6b2c3c42fcd315a3c8fa6a319e"
    sha256 cellar: :any_skip_relocation, sonoma:        "987b018ffbc00c48bc342c45ac5cb345df46b831063709b7d7e711d44c5cd01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aadf784165e98c365df505057e07b0e3dd2b49f07bda9b06bbd63cc3c93989b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09055cbd39b296247fe611ae69248401725a5af55e58351d87aa9c54fbe4ef60"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    tags = %w[
      sqlite_omit_load_extension sqlite_json sqlite_fts5
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end
