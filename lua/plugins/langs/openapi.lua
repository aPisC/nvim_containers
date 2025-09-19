return {
  {
    "vinnymeller/swagger-preview.nvim",
    build = "npm i",
    opts = {
      -- The port to run the preview server on
      port = 8888,
      -- The host to run the preview server on
      host = "localhost",
    }
  },
}
