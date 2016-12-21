class NoticeOfDefaultLeadLobLetter < LobLetter

  def html
    "
    <html>
    <head>
    <style>
      .text-center {
        text-align: center;
      }
      .indent {
        text-indent: 50px;
      }
    </style>
    </head>

    <body>
      <div id='letter'>
        <div class='text-center'>
          <address>
            <strong>Nick Reedy</strong>
            <br />
            9663 South Candle Tree Ln
            <br />
            Sandy, Utah 84092
            <br />
            (801)-739-2312
            <br />
            nickreedy@icloud.com
          </address>
        </div>

        <br />

        <p>Dear {{name}}</p>

        <p class='indent'>We noticed your home at {{address}}, {{city}}, {{state}}, {{zip}} is in default.</p>

        <p>We can stop the foreclosure - <strong>without bankruptcy</strong>.</p>

        <ol>
          <li>We help you keep/stay in your home and lower your monthly payments</li>
          <li>We give you cash now and you can stay in your home as long as you need</li>
        </ol>

        <p>We have helped over 110 homeowners in your situation avoid foreclosure.</p>

        <p>For details please call me at (801) 739-2312</p>

        <br />
        <p>Sincerely,</p>
        <br />

        <address>
          <strong>Nick Reedy</strong>
          <br>
          (801)-739-2312
        </address>
      </div>
    </body>

    </html>
    "
  end

end