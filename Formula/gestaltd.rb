# frozen_string_literal: true

class Gestaltd < Formula
  desc "Gestalt server daemon"
  homepage "https://github.com/valon-technologies/gestalt"
  version "0.0.2-alpha.58"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestaltd/v0.0.2-alpha.58/gestaltd-macos-arm64.tar.gz"
      sha256 "e47538e00d144aa106df1099777cccba89e5dbf8819a5c80abcf4593114f5050"
    end

    on_intel do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestaltd/v0.0.2-alpha.58/gestaltd-macos-x86_64.tar.gz"
      sha256 "8b883ea355bc1cd03440d34e1f5ced83af9bfa1ac5653e8e6ba0d0309c048271"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestaltd/v0.0.2-alpha.58/gestaltd-linux-arm64.tar.gz"
      sha256 "f4d7e0dc0972e620e61d92289f66654919b57197e8c42ef2ef7d7116b01d1da2"
    end

    on_intel do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestaltd/v0.0.2-alpha.58/gestaltd-linux-x86_64.tar.gz"
      sha256 "3aacf198948ff2dc83e2ef629668e8103f63cd79c4fb55d6f0a2c78557068951"
    end
  end

  def install
    bin.install "gestaltd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gestaltd version")
  end
end
