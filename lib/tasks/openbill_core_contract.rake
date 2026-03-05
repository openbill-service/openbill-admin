namespace :openbill_core do
  desc "Verify openbill-core DB contract required by admin"
  task verify_contract: :environment do
    OpenbillCore::Contract.new.verify!
    puts "openbill-core contract verified"
  end
end
