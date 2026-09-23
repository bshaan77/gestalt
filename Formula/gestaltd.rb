# frozen_string_literal: true

class Gestaltd < Formula
  desc "Gestalt server daemon"
  homepage "https://github.com/valon-technologies/gestalt"
  version "0.0.2-alpha.57"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestaltd/v0.0.2-alpha.57/gestaltd-macos-arm64.tar.gz"
      sha256 "197c0b8339a171dd39e9979680bd6fedecaca49974fe4e0da602a996c75d0f4f"
    end

    on_intel do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestaltd/v0.0.2-alpha.57/gestaltd-macos-x86_64.tar.gz"
      sha256 "0af42bb362f5c841d870ad69cdf67fb53c43c685672d41416bff1948158c1240"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestaltd/v0.0.2-alpha.57/gestaltd-linux-arm64.tar.gz"
      sha256 "02d88efec26b63b2cdd927a478ad631355243237867ac85f7e1dfeef32e4e2a0"
    end

    on_intel do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestaltd/v0.0.2-alpha.57/gestaltd-linux-x86_64.tar.gz"
      sha256 "20f4c0a97f72f976010a363ece7e4b0fa5fac4720e9c75cd851f2b7e603a9e74"
    end
  end

  def install
    bin.install "gestaltd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gestaltd version")
  end
end
