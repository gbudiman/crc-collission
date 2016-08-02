require 'rails_helper'

RSpec.describe Crc, type: :model do
  # it "should compute CRC correctly" do
  #   c = Crc.new
  #   c.dataword = 0xDDA
  #   # c.crc_bits = 5
  #   #c.compute
  #   c.calculate
  # end

  # it "should compute CRC without displaying steps" do
  #   c = Crc.new
  #   c.display_steps = false
  #   c.calculate
  # end

  # it "should compute reverse CRC correctly" do
  #   c = Crc.new
  #   c.dataword = 1482
  #   c.crc_bits = 5
  #   c.calculate
  # end

  # it "should be able to compute corner case" do
  #   c = Crc.new
  #   c.crc_bits = 5
  #   c.dataword = 0x4EF
  #   c.calculate
  # end

  it "should be able to detect burst length error" do
    c = Crc.new
    c.dataword = 3327
    bel = c.determine_burst_error_length_against 0xDDA
    expect(bel).to eq 9
  end

  it "should be able to brute force CRC" do
    res = Hash.new
    c = Crc.new
    c.display_steps = false
    c.crc_bits = 5
    (0x0..0xFFF).each do |i|
      c.dataword = i
      c.calculate
      if c.remainder == 0
        bit_flipped = c.determine_burst_error_length_against 0xDDA
        res[bit_flipped] ||= Array.new
        res[bit_flipped].push i
      end
    end

    ap Hash[res.sort]
  end
end