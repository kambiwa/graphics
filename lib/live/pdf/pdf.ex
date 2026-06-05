defmodule Graphics.Pdf.QuotationPdf do
  @moduledoc """
  Generates a PDF quotation from a Quotation struct.
  Returns {:ok, binary} or {:error, reason}.
  """

    def generate(quotation) do
      html = render_html(quotation)

      with {:ok, encoded_pdf} <- ChromicPDF.print_to_pdf({:html, html}) do
        {:ok, Base.decode64!(encoded_pdf)}
      end
    end



  defp render_html(q) do
    service_label = String.capitalize(q.service_type || "")
    date_label    = if q.event_date, do: Calendar.strftime(q.event_date, "%d %B %Y"), else: "TBC"
    amount        = q.amount |> Decimal.to_string() |> format_price()

    drone_row     = if q.drone_coverage, do: line_item("Drone Coverage", "1,200"), else: ""
    video_row     = if q.videography,    do: line_item("Videography",    "1,800"), else: ""

    hourly_rate   = hourly_for(q.service_type)
    base_price    = base_for(q.service_type)

    """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8"/>
      <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #1a1a18; background: #fff; padding: 48px 56px; font-size: 13px; }

        .header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 48px; }
        .brand-name { font-size: 28px; font-weight: 800; letter-spacing: 0.15em; text-transform: uppercase; }
        .brand-sub  { font-size: 10px; font-weight: 600; letter-spacing: 0.22em; text-transform: uppercase; color: #E05C3A; margin-top: 2px; }
        .meta       { text-align: right; }
        .meta p     { font-size: 11px; color: #6b6b67; line-height: 1.8; }
        .meta .qt-number { font-size: 13px; font-weight: 700; color: #1a1a18; }

        .divider { border: none; border-top: 0.5px solid rgba(26,26,24,0.15); margin: 0 0 32px; }

        .section-label { font-size: 9px; font-weight: 700; letter-spacing: 0.2em; text-transform: uppercase; color: #6b6b67; margin-bottom: 16px; }

        .details-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px 32px; margin-bottom: 40px; }
        .detail-row   { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 0.5px solid rgba(26,26,24,0.07); }
        .detail-label { color: #6b6b67; }
        .detail-value { font-weight: 600; }

        table { width: 100%; border-collapse: collapse; margin-bottom: 24px; }
        thead th { font-size: 9px; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; color: #6b6b67; padding: 8px 12px; border-bottom: 0.5px solid rgba(26,26,24,0.15); text-align: left; }
        thead th:last-child { text-align: right; }
        tbody td { padding: 10px 12px; border-bottom: 0.5px solid rgba(26,26,24,0.07); font-size: 13px; }
        tbody td:last-child { text-align: right; font-weight: 600; }

        .total-row { background: #1a1a18; }
        .total-row td { color: #FAF9F7 !important; font-weight: 700; font-size: 14px; padding: 12px; border-bottom: none; }
        .total-row td:last-child { color: #E05C3A !important; font-size: 16px; }

        .footer { margin-top: 56px; padding-top: 20px; border-top: 0.5px solid rgba(26,26,24,0.1); display: flex; justify-content: space-between; align-items: flex-end; }
        .footer-note { font-size: 10px; color: #6b6b67; line-height: 1.7; max-width: 360px; }
        .footer-brand { font-size: 10px; color: #6b6b67; text-align: right; }

        .status-badge { display: inline-block; padding: 3px 10px; border-radius: 999px; font-size: 9px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; background: #fef3c7; color: #92400e; }
      </style>
    </head>
    <body>

      <div class="header">
        <div>
          <div class="brand-name">Jaguar</div>
          <div class="brand-sub">Photography</div>
        </div>
        <div class="meta">
          <p class="qt-number">#{q.quotation_number}</p>
          <p>Date: #{Calendar.strftime(Date.utc_today(), "%d %B %Y")}</p>
          <p>Valid for 30 days</p>
          <p style="margin-top:6px;"><span class="status-badge">#{String.upcase(q.status || "draft")}</span></p>
        </div>
      </div>

      <hr class="divider"/>

      <p class="section-label">Quotation Details</p>
      <div class="details-grid">
        <div>
          <div class="detail-row"><span class="detail-label">Service</span><span class="detail-value">#{service_label}</span></div>
          <div class="detail-row"><span class="detail-label">Event Date</span><span class="detail-value">#{date_label}</span></div>
          <div class="detail-row"><span class="detail-label">Hours</span><span class="detail-value">#{q.hours} hr#{if q.hours != 1, do: "s"}</span></div>
        </div>
        <div>
          <div class="detail-row"><span class="detail-label">Drone Coverage</span><span class="detail-value">#{if q.drone_coverage, do: "Yes", else: "No"}</span></div>
          <div class="detail-row"><span class="detail-label">Videography</span><span class="detail-value">#{if q.videography, do: "Yes", else: "No"}</span></div>
          <div class="detail-row"><span class="detail-label">Prepared by</span><span class="detail-value">Jaguar Photography</span></div>
        </div>
      </div>

      <p class="section-label">Price Breakdown</p>
      <table>
        <thead>
          <tr>
            <th>Description</th>
            <th>Unit</th>
            <th>Qty</th>
            <th>Amount (ZMW)</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>#{service_label} Photography — Base Package</td>
            <td>Package</td>
            <td>1</td>
            <td>K #{format_price("#{base_price}")}</td>
          </tr>
          <tr>
            <td>#{service_label} Photography — Hourly Coverage</td>
            <td>per hr</td>
            <td>#{q.hours}</td>
            <td>K #{format_price("#{q.hours * hourly_rate}")}</td>
          </tr>
          #{drone_row}
          #{video_row}
          <tr class="total-row">
            <td colspan="3">TOTAL ESTIMATE</td>
            <td>K #{amount}</td>
          </tr>
        </tbody>
      </table>

      <div class="footer">
        <div class="footer-note">
          This is an estimate only. Final pricing may vary based on travel,<br/>
          additional hours, or specific requirements discussed at consultation.<br/>
          A 50% deposit is required to confirm your booking.
        </div>
        <div class="footer-brand">
          Jaguar Photography<br/>
          Lusaka, Zambia<br/>
          +260 XXX XXX XXX
        </div>
      </div>

    </body>
    </html>
    """
  end

  defp line_item(label, amount) do
    """
    <tr>
      <td>#{label}</td>
      <td>Add-on</td>
      <td>1</td>
      <td>K #{amount}</td>
    </tr>
    """
  end

  defp base_for(type) do
    %{"wedding" => 3500, "graduation" => 1200, "portrait" => 800, "corporate" => 2500, "event" => 1800}
    |> Map.get(type, 0)
  end

  defp hourly_for(type) do
    %{"wedding" => 300, "graduation" => 150, "portrait" => 100, "corporate" => 250, "event" => 200}
    |> Map.get(type, 0)
  end

  defp format_price(str) do
    str
    |> String.reverse()
    |> String.graphemes()
    |> Enum.chunk_every(3)
    |> Enum.join(",")
    |> String.reverse()
  end
end
