class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.34.0",
      revision: "959a56cda79509e66abd367a6498951b656aa460"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff83a6161078845d614c79e71f1d7e06bd0afd482137f7b602d6f744b87dc144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb999ed7902f650cfa45e51d0569b60c210ca034b4e8c2650a1da66d8206d76a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bf89cc165c2059febde14458e62a0058443071ae309731d1a05b9bcae60d20f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7849e5ff7fc1019e1baebe37723434f27efa01c8657086f3a21c9443def461c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bba07c437f7462cf5178c70fa0b53506286ea4f91cd1011b6014b5ed6724c8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac239ddda66da1608c0d1e48f0a62f8b821897c4486f4d3f7d23b9a06812645c"
  end

  depends_on xcode: ["15.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "protoc-gen-swift"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    PROTO
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_path_exists testpath/"test.pb.swift"
  end
end
