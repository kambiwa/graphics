defmodule Graphics.Context.CxtQuotation do
  alias Graphics.Quotation
  alias Graphics.Repo

  @base_prices %{
    "wedding"    => Decimal.new("3500"),
    "graduation" => Decimal.new("1200"),
    "portrait"   => Decimal.new("800"),
    "corporate"  => Decimal.new("2500"),
    "event"      => Decimal.new("1800")
  }

  @hourly_rates %{
    "wedding"    => Decimal.new("300"),
    "graduation" => Decimal.new("150"),
    "portrait"   => Decimal.new("100"),
    "corporate"  => Decimal.new("250"),
    "event"      => Decimal.new("200")
  }

  @drone_fee      Decimal.new("1200")
  @videography_fee Decimal.new("1800")

  def list_quotations, do: Repo.all(Quotation)

  def get_quotation!(id), do: Repo.get!(Quotation, id)

  def create_quotation(attrs \\ %{}) do
    attrs_with_number = Map.put_new(attrs, "quotation_number", generate_quotation_number())

    %Quotation{}
    |> Quotation.changeset(attrs_with_number)
    |> Repo.insert()
  end

  def update_quotation(%Quotation{} = quotation, attrs) do
    quotation
    |> Quotation.changeset(attrs)
    |> Repo.update()
  end

  def delete_quotation(%Quotation{} = quotation), do: Repo.delete(quotation)

  def change_quotation(%Quotation{} = quotation, attrs \\ %{}) do
    Quotation.changeset(quotation, attrs)
  end

  def calculate_amount(service_type, hours, drone_coverage, videography) do
    base      = Map.get(@base_prices, service_type, Decimal.new("0"))
    hourly    = Map.get(@hourly_rates, service_type, Decimal.new("0"))
    drone     = if drone_coverage, do: @drone_fee, else: Decimal.new("0")
    video     = if videography, do: @videography_fee, else: Decimal.new("0")
    hours_d   = Decimal.new(hours)

    base
    |> Decimal.add(Decimal.mult(hourly, hours_d))
    |> Decimal.add(drone)
    |> Decimal.add(video)
  end

  defp generate_quotation_number do
    date  = Date.utc_today() |> Calendar.strftime("%Y%m%d")
    rand  = :crypto.strong_rand_bytes(3) |> Base.encode16()
    "QT-#{date}-#{rand}"
  end
end
