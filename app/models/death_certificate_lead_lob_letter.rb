class DeathCertificateLeadLobLetter < LobLetter

  def initialize(fields)
    super(fields)
    self.date = Date.today.strftime("%B %e, %Y")
  end

  def html
    "
    <html>
    <head>
    <style>
      #{styles}
    </style>
    </head>

    <body>
      <div>
        <p>Dear {{name}}</p>

        <p class='indent'>Hello, my name is Nick and I would like to offer my condolences on
        the passing of {{deceased}}. I too have lost loved ones and know how difficult this can be.</p>

        <p class='indent'>It is my understanding, through the Salt Lake County recorders office, the property located at {{address}}, {{city}}, {{state}}, {{zip}} may be available to purchase. I’m sure at this time selling this property is probably not a priority for your family, but if in the near future you decide to sell, please call me and allow me the opportunity to make you an offer.
        </p>
        <hr />
        <strong>Many people choose to sell to me for the following reasons:</strong>

        <ul>
          <li>You pay no realtor commissions, closing costs or title fees</li>
          <li>I buy the property in “as is” condition, no repairs required</li>
          <li>Your tenants don’t have to move, I can be flexible and discrete</li>
          <li>I can close in as little as 24 hours or at your convenience</li>
        </ul>
        <hr />

        <p class='indent'>While I do not know your particular situation, I am prepared to do what is best for you and the estate. Feel free to call me with any questions. <strong>(801)-739-2312</strong></p>

        <br />
        <br />

        <p>My warmest regards,</p>

        <br />
        <br />
        <br />
        <br />

        <address>
          <strong>Nick Reedy</strong>
          <br>
          (801)-739-2312
        </address>

        <p>PS.  I can usually pay the same or even more than what you would make if you listed with a realtor and paid commissions, repairs, closing costs and title fees.</p>
      </div>
    </body>

    </html>
    "
  end

end