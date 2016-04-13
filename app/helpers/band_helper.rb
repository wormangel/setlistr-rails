module BandHelper
  def instruments_dropdown
    Enum.new ([
       [:guitar, Contract.human_attribute_name("instrument.guitar")],
       [:bass, Contract.human_attribute_name("instrument.bass")],
       [:vocals, Contract.human_attribute_name("instrument.vocals")],
       [:drums, Contract.human_attribute_name("instrument.drums")],
       [:keyboard, Contract.human_attribute_name("instrument.keyboard")]
       ])
  end

end
