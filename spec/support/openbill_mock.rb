module OpenbillMock
  def stub_openbill
    service = double
    allow(Openbill).to receive(:service).and_return service
  end
end