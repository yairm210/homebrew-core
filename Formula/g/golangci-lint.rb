class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.10.1",
      revision: "5d1e709b7be35cb2025444e19de266b056b7b7ee"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "657c9e485a3d5717bc019105686ccc5693b03fb1a5b42dc015db5100b95a426b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6907e7e24b9907056e3682e9c12c0ca881add3abbb42c818f913049f46b3e8d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25503e3ebc02b4df90453bbfa7663141df40e867f075042e1c6a46ba4e617485"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c703406987606df301c4afce97981a4df8fdb6407d9c6eb054428b754bed477"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78da992c0e6ba5d98b4b27099bbb34edfa173bc4fd351707c4c0d1efbc9421bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28b2c928a033e5104e07b8891e4e0be23146090bd6d9c9dc68a8f89c16abe172"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", shell_parameter_format: :cobra)
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end
