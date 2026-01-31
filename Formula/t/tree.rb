class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "https://oldmanprogrammer.net/source.php?dir=projects/tree"
  url "https://github.com/Old-Man-Programmer/tree/archive/refs/tags/2.3.0.tar.gz"
  sha256 "2300cc786dc2638956531b421326f257db7876619d811f5ef5d6120907172078"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef884002e8601fb801ed14e025d3138a48b74b8a4fa735230a849d4ce0d0fa8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccfac896234e1c63841b421873387c407f375af7e6db54abea549d24e3c69589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a290f08288dc441d0842aeb0fc5d27e2ebb890ad0ef03680c08fddf4b6281252"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4eded180a935460b5b2d0cc50504197e29d4b9cbd04d20b800860c73e81d930"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d54f8fe160c9508e5a85b4245900a9458200cac58e5a2105eef7fa75564884"
    sha256 cellar: :any_skip_relocation, ventura:       "834f7d3715e67ca1b3b24fc3979c0290ab81e0fdd22ad971c8d25746457a6693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f416641929a817a779910d616492604eece253c52fb062034a1822cd953cf76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45f02a1a405f4782d3e26963f7f37b3842e9857b06cd36cc0e5945cbeeb55758"
  end

  # Workaround for https://github.com/Old-Man-Programmer/tree/issues/30
  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"tree", prefix
  end
end

__END__
diff --git a/tree.c b/tree.c
index 2d719c4..fa0fba1 100644
--- a/tree.c
+++ b/tree.c
@@ -1564,7 +1564,9 @@ char *fillinfo(char *buf, const struct _info *ent)
   if (flag.g) n += sprintf(buf+n, " %-8.32s", gidtoname(ent->gid));
   if (flag.s) n += psize(buf+n,ent->size);
   if (flag.D) n += sprintf(buf+n, " %s", do_date(flag.c? ent->ctime : ent->mtime));
+  #ifdef __linux__
   if (flag.selinux) n += sprintf(buf+n, " %s", ent->secontext);
+  #endif
 
   if (buf[0] == ' ') {
       buf[0] = '[';
