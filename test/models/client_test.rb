require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def new_client
    clients(:juan)		
  end
  
  test "client attributes must not be empty" do
    client = Client.new
    assert client.invalid?
    assert client.errors[:legal_representative].any?	
    assert client.errors[:address].any?
    assert client.errors[:organization].any?    
  end
  
  test "unique clients" do
    client = new_client
    
    another_client = Client.new(client.attributes)
    
    assert another_client.invalid?  
    
    assert_equal ['ya existe'],
      another_client.errors[:legal_representative]
  end
end