module Shoperb module Theme module Editor
  module Mounter
    module Model
      class PaymentMethod < Base

        fields :id, :name, :state, :invoice_instructions, :instructions

        def payment_method
          self
        end

        def display_name
          name
        end

        def succeed?
          state == "captured"
        end

        def self.raw_data
          [{
            id: 1,
            name: "Credit card payment",
            provider: "Braintree",
            state: "failed",
            invoice_instructions: nil,
            checkout_instructions: nil,
            bank_account: nil,
            bank_name: nil,
            bic_swift_code: nil,
            },
            {
              id: 2,
              name: "Invoice payment",
              provider: "Credit Card",
              state: "captured",
              invoice_instructions: nil,
              checkout_instructions: nil,
              bank_account: nil,
              bank_name: nil,
              bic_swift_code: nil,
            },
            {
              id: 3,
              name: "Invoice payment",
              provider: "Credit Card",
              state: "captured",
              invoice_instructions: "После оформления заказа в интернете на Ваш адрес электронной почты автоматически будет выслан счет для оплаты.\n
                        ПРЕЖДЕ ЧЕМ ОПЛАТИТЬ СЧЕТ, ДОЖДИТЕСЬ ЗВОНКА НАШЕГО АДМИНИСТРАТОРА ПО ПРОДАЖАМ.\n\n
                        Мы свяжемся с Вами, исползуя контактную информацию, которую указали во время оформления заказа, чтобы информаровать
                        Вас о времени, когда сможете получить свои заказ. Получение заказа может длится от 1-7 дней, в зависимости от того,
                        являэтся лы товар на складе.\n\nВ ПОЛЕ ПРИЧИНА (КОММЕНТАРИЙ) К ПЛАТЕЖУ УКАЖИТЕ НОМЕР СЧЕТА ИЛИ ЗАКАЗА (№) ! ! !\n\n
                        Вы можете оплатить счет в:\n\nвашем интернет-банке;\nфилиале банка",
              checkout_instructions: nil,
              bank_account: "Mike Billman\nLV05HAB00551000009999",
              bank_name: "A/S Swedbank",
              bic_swift_code: "LV05HAB0",
            }
          ]
        end

      end
    end
  end
end end end
