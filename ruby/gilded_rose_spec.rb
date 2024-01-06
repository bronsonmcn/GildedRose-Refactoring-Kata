require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'rspec'

RSpec.describe GildedRose do
  let(:items) {[item]}
  let(:item) {Item.new(name, sell_in, quality)}
  let(:name) {"Generic Item"}
  let(:sell_in) {10}
  let(:quality) {5}
  subject { described_class.new(items).update_item}

  describe "#update_item" do
    it "does not change the name" do
      subject
      expect(items[0].name).to eq "Generic Item"
    end

    it "decreases the sell_in by 1" do
      subject
      expect(items[0].sell_in).to eq 9
    end

    it "decreases the quality by 1" do
      subject
      expect(items[0].quality).to eq 4
    end

    context "when the sell_in is 0" do
      let(:sell_in) {0}

      it "decreases to quality by 2" do
        subject
        expect(items[0].quality).to eq 3
        expect(items[0].sell_in).to eq -1
      end
    end

    context "when the quality is 0" do
      let (:quality) {0}

      it "does not become negative" do
        subject
        expect(items[0].quality).to eq 0
      end
    end

    context "when the item is Aged Brie" do
      let(:name) {Constants::AGED_BRIE}

      it "increases the quality by 1" do
        subject
        expect(items[0].quality).to eq 6
        expect(items[0].sell_in).to eq 9
      end

      context "and the sell_in is 0" do
        let(:sell_in) {0}

        it "increases the quality by 2" do
          subject
          expect(items[0].quality).to eq (quality + 2)
        end
      end

      context "and the quality is 50" do
        let(:quality) {50}

        it "does not increase the quality" do
          subject
          expect(items[0].quality).to eq 50
        end
      end
    end

    context "when the item is legendary" do
      let(:name) {Constants::LEGENDARY}
      let(:quality) {80}

      it "never has to be sold" do
        subject
        expect(items[0].sell_in).to eq sell_in
      end

      it "never decreases in quality" do
        subject
        expect(items[0].quality).to eq 80
      end
    end

    context "when the item is a backstage pass" do
      let(:name) {Constants::BACKSTAGE_PASS}

      context "and sell_in is 10 or less" do
        let(:sell_in) {10}

        it "increases the quality by 2" do
          subject
          expect(items[0].quality).to eq (quality + 2)
        end
      end

      context "and sell_in is 5 or less" do
        let(:sell_in) {5}

        it "increases the quality by 3" do
          subject
          expect(items[0].quality).to eq (quality + 3)
        end
      end

      context "and sell_in is 0" do
        let(:sell_in) {0}

        it "sets the quality to 0" do
          subject
          expect(items[0].quality).to eq 0
        end
      end
    end

    context "when the item is a conjured item" do
      let(:name) {Constants::CONJURED}

      it "degrades in quality twice as fast" do
        subject
        expect(items[0].quality).to eq (quality - 2)
      end

      context "and sell_in is 0" do
        let (:sell_in) {0}
        
        it "degrades in quality four times as fast" do
          subject
          expect(items[0].quality).to eq (quality - 4)
        end
      end
    end
  end
end
