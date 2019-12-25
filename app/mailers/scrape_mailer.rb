class ScrapeMailer < ApplicationMailer
    def send_mail(date, titles, authors, abstracts)
        @date = date
        @titles = titles
        @authors = authors
        @abstracts = abstracts
        mail(
          from: 'scrapearxiv@gmail.com',
          to:   'yuta.u1969@gmail.com',
          subject: @date
        )
    end
end
