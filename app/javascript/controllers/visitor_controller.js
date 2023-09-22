import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  downloadTableAsJson(event) {
    var json_info = JSON.parse(
      event.currentTarget.dataset.visitorInfoCotization
    );

    var exportName = "Inversion de cliptomonedas";
    var dataStr =
      "data:text/json;charset=utf-8," +
      encodeURIComponent(JSON.stringify(this.filter_json_data(json_info)));
    var downloadAnchorNode = document.createElement("a");
    downloadAnchorNode.setAttribute("href", dataStr);
    downloadAnchorNode.setAttribute("download", exportName + ".json");
    document.body.appendChild(downloadAnchorNode); // required for firefox
    downloadAnchorNode.click();
    downloadAnchorNode.remove();
  }

  downloadTableAsCSV(event) {
    var json_info = JSON.parse(
      event.currentTarget.dataset.visitorInfoCotization
    );

    const data = this.filter_json_data(json_info);

    const csvdata = this.csvmaker(data);
    this.downloadCSV(csvdata);
  }

  downloadCSV(data) {
    const blob = new Blob([data], { type: "text/csv" });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement("a");

    a.setAttribute("href", url);
    a.setAttribute("download", "Inversion de cliptomonedas.csv");
    a.click();
  }

  csvmaker(data) {
    var csvRows = [];
    const headers = Object.keys(data[0]);
    csvRows.push(headers.join(","));

    // Looping through the data values and make
    // sure to align values with respect to headers
    for (const row of data) {
      const values = headers.map((e) => {
        return row[e];
      });
      csvRows.push(values.join(","));
    }

    return csvRows.join("\n");
  }

  filter_json_data(json_collection) {
    return json_collection.map((row) => ({
      Moneda: row.name,
      Precio: row.rate,
      "Capital + Rendimiento Anual": row.rate_anual_gain,
      "Capital + Rendimiento Anual Compuesto": row.rate_anual_gain_compound,
    }));
  }
}
