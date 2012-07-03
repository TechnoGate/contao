require 'spec_helper'

module TechnoGate
  module Contao
    describe Password do
      let(:clear_password) { 'password' }
      let(:password)       { '52c938dedcdc146d0a3f5fef834e9881be343d6c' }
      let(:salt)           { '537a4e714483674274a2b07' }
      let(:password_hash)  { "#{password}:#{salt}" }

      describe 'class methods' do
        subject { Password }

        describe '#create' do

          it { should respond_to :create }

          it 'should return an instance of Password' do
            subject.create(clear_password).should be_instance_of Password
          end

          it 'should return an instance with @password_hash and @salt set' do
            p = subject.create clear_password
            p.instance_variable_get(:@password_hash).should_not be_nil
            p.instance_variable_get(:@salt).should_not be_nil
          end

          it 'should split the password_hash into instance variables' do
            Password.should_receive(:generate_salt).and_return salt

            p = subject.create clear_password
            p.instance_variable_get(:@password_hash).should == password
            p.instance_variable_get(:@salt).should == salt
          end
        end

        describe '#generate_salt' do
          it { should respond_to :generate_salt }

          it 'should return a salt' do
            subject.send(:generate_salt).should_not be_nil
          end

          it 'should be of the size of SALT_SIZE' do
            subject.send(:generate_salt).size.should == Password::SALT_SIZE
          end
        end

        describe '#random' do
          it {should respond_to :random}

          it 'should return a random string' do
            subject.send(:random).should_not be_nil
          end

          it 'should honor the requested length' do
            subject.send(:random, 14).size.should == 28
          end

          it 'should be 128 chars by default' do
            subject.send(:random).size.should == 128
          end

          it 'should be a string' do
            subject.send(:random).should be_instance_of String
          end
        end
      end

      describe 'initialization' do
        subject { Password.new password_hash }

        it 'should split the password_hash into instance variables' do
          subject.instance_variable_get(:@password_hash).should == password
          subject.instance_variable_get(:@salt).should == salt
        end
      end

      describe 'instance methods' do
        subject { Password.new password_hash }

        describe 'to_s' do
          it 'should return the password_hash' do
            subject.to_s.should == password_hash
          end
        end
      end
    end
  end
end
