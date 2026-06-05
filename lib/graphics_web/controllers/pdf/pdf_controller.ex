defmodule GraphicsWeb.QuotationPdfController do
  use GraphicsWeb, :controller

  alias Graphics.Context.CxtQuotation
  alias Graphics.Pdf.QuotationPdf

  def download(conn, %{"id" => id}) do
    quotation = CxtQuotation.get_quotation!(id)

    case QuotationPdf.generate(quotation) do
      {:ok, pdf_binary} ->
        conn
        |> put_resp_content_type("application/pdf")
        |> put_resp_header(
          "content-disposition",
          ~s(attachment; filename="#{quotation.quotation_number}.pdf")
        )
        |> send_resp(200, pdf_binary)

      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not generate PDF: #{inspect(reason)}")
        |> redirect(to: ~p"/")
    end
  end
end
