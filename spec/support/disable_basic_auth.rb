RSpec.configure do |config|
  config.before(type: :system) do
    allow_any_instance_of(ApplicationController)
      .to receive(:basic_auth).and_return(true)
  end
end
