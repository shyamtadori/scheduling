require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable
      def authenticate!
        puts "="*120
        puts "in authenticate"
        puts "="*120
        no_password_needed = true
        if username.present? and password.present?
          ldap = Net::LDAP.new
          ldap.host = "ehwdca101.erahelicopters.com"
          ldap.base = "DC=erahelicopters,DC=com"
          ldap.port = 389
          
          ldap.auth "svc-ramco@erahelicopters.com", "R@mc0s3rv"
          if ldap.bind
            search_result = ldap.search(:filter => "(sAMAccountName=#{username.downcase})")

            if search_result.present? 
              if search_result.first[:lockouttime].present? and search_result.first[:lockouttime].first != "0"
                fail!(message = "Your account is temporarily locked" )
              else
                if !no_password_needed
                  result = ldap.bind_as(
                            :base => "OU=Era Employees,DC=erahelicopters,DC=com",
                            :filter => "(sAMAccountName=#{username.downcase})",
                            :password => password
                          )
                end
                if no_password_needed or result
                  if User.where('lower(username)  = ? ', username.downcase).present?  
                    puts "="*120
                    puts "username found in db"
                    puts "="*120
                    user = User.where('lower(username)  = ? ', username.downcase).first
                    session[:org_unit] = user.org_unit
                    success!(user)
                  else
                    puts "="*120
                    puts "username not found in db"
                    puts "="*120
                  end
                else
                  puts "username bind failed"
                  fail!(message = "Username or password incorrect")
                end
              end
            else
              puts "user not in AD"
              fail!(message = "Username or password incorrect")
            end
          else
              puts "ramco bind failed"
              fail!(message = "Username or password incorrect")
          end
        elsif request.post?
          puts "missing uername or password"
          fail!(message = "Username or password incorrect")
        end
      end

      def username
        params[:user][:username]
      end

      def password
        params[:user][:password]
      end

    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)