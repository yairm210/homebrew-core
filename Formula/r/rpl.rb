class Rpl < Formula
  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://github.com/rrthomas/rpl/releases/download/v2.0.4/rpl-2.0.4.tar.gz"
  sha256 "cb48bf6712cd4e7aa70b2225dcab0cb081582181d7e9766ada196b3ab5b2ec61"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f30ceeb460bc67d3594e702e9de5c42ba913a5388515b754d6225542e6d18fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db734192128a7e60d98bf9d06faa0086d0abfa483201e93db0e877c20566b91f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f80cd4cfbaebbd99d7d4f99c4484d88335707ed458253fde37653e1928cf904"
    sha256 cellar: :any_skip_relocation, sonoma:        "47fab5f6519ffeea8846065f66842a6b13b2e825c2542f93065ea0e3aa42bb8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a50d816a8cbc804290630c63e1a7a4fae2fdfc702ff3424db8d6dd1ce8a875ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bb1e34afdd4f02172a30480efb626a835b70e988fe37b020aa4312d0453f02"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "pcre2"
  depends_on "uchardet"

  on_macos do
    depends_on "gettext"
  end

  # TODO: Remove next release
  resource "vala-extra-vapis" do
    url "https://gitlab.gnome.org/GNOME/vala-extra-vapis/-/archive/6b8a3e4faaabc462f90ffcb0cf0f91991ee58077/vala-extra-vapis-6b8a3e4faaabc462f90ffcb0cf0f91991ee58077.tar.bz2"
    sha256 "161fbc1e2ac51886ec52c0ee8db69d6afe408279ec79a8bea2b472a23fef9e99"
  end

  # Backport fix for newer PCRE2.
  # TODO: Remove patch and `vala` dependency in next release
  patch do
    url "https://github.com/rrthomas/rpl/commit/6e452376e32c230819078d92248433e800878bb0.patch?full_index=1"
    sha256 "3b3634aaeff9e0eac0f3ec22a1a0346c1c56c8fd30a38aa12d90b3e5b71ce0fa"
  end

  def install
    (buildpath/"vala-extra-vapis").install resource("vala-extra-vapis")

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
