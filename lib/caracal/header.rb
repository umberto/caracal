require 'caracal/abstract_header_and_footer'

module Caracal
  class Header < AbstractHeaderAndFooter
    def relationship_params
      { target: "header#{index}.xml", type: :header, owner: self }
    end
  end
end
