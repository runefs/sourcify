require File.expand_path('../spec_helper', __FILE__)

describe Sourcify::Proc::Source do

  before do
    @proc = proc do # [6,12] .. [9,9]]]
      # blah blah
      :nil
    end

    @line = __LINE__ - 5
    @source = Sourcify::Proc::Source.new(@proc)
  end


  describe '#metadata' do
    before { @metadata = @source.metadata }

    it 'must capture file' do
      @metadata.file.must_equal(__FILE__)
    end

    it 'must capture sexp' do
      @metadata.sexp.must_equal(
        [:method_add_block,
         [:method_add_arg, [:fcall, [:@ident, "proc", [@line, 12]]], [:args_new]],
         [:do_block,
          nil,
          [:stmts_add,
           [:stmts_new],
           [:symbol_literal, [:symbol, [:@kw, "nil", [@line+2, 7]]]]]]]
      )
    end

    it 'must capture start position' do
      @metadata.from_pos.must_equal([@line, 12])
    end

    it 'must capture end position' do
      @metadata.till_pos.must_equal([@line+3, 7])
    end

    it 'must capture reference object' do
      @metadata.object.inspect.must_equal(@proc.inspect)
      #@metadata.object.must_be_same_as(@proc) # Hmm, why this doesn't work ??
    end
  end


  describe '#raw' do
    before { @raw_source = @source.raw }

    it 'must return an instance of Sourcify::Proc::RawSource' do
      @raw_source.must_be_instance_of(Sourcify::Proc::RawSource)
    end

    it 'must have source & raw source sharing the same metadata' do
      @raw_source.metadata.must_be_same_as(@source.metadata)
    end
  end 


  describe '#to_s' do
    it 'should return socerer\'s output' do
      @source.to_s.must_equal('proc do :nil end')
    end
  end

end
