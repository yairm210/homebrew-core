class Jqfmt < Formula
  desc "Opinionated formatter for jq"
  homepage "https://github.com/noperator/jqfmt"
  url "https://github.com/noperator/jqfmt/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5435c3166921ea103513d516c4d56ee00755d6b0b798f3edbdabfc06a1d98268"
  license "MIT"
  head "https://github.com/noperator/jqfmt.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/jqfmt/main.go"
  end

  test do
    input = "{one: .two, three: [.four, .five, [.fivetwo, .fivethree]], six: map(select((.seven | .eight | .nine)))}"
    expected = <<~JQ.strip
      {
          one: .two,
          three: [
              .four,
              .five,
              [
                  .fivetwo,
                  .fivethree
              ]
          ],
          six: map(select((.seven | .eight | .nine)))
      }
    JQ
    test_file = testpath/"test.jq"
    test_file.write(input)
    no_trailing_spaces = ->(subject) { subject.chomp.split("\n").map(&:rstrip).join("\n") }
    assert_match expected, no_trailing_spaces.call(shell_output("#{bin}/jqfmt -ob -ar -f #{test_file}"))
  end
end
