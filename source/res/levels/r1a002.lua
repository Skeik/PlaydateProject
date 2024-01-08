return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 15,
  height = 10,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 6,
  nextobjectid = 19,
  properties = {},
  tilesets = {
    {
      name = "greyscaje",
      firstgid = 1,
      filename = "../../../../MapAssets/untitled2.tsx"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 15,
      height = 10,
      id = 3,
      name = "AUTO",
      class = "",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        18, 15, 1, 16, 34, 35, 13, 35, 12, 0, 0, 0, 0, 0, 0,
        42, 15, 13, 4, 45, 44, 12, 33, 18, 1, 35, 14, 46, 35, 44,
        0, 0, 3, 36, 1, 12, 46, 44, 18, 1, 1, 1, 1, 1, 1,
        0, 18, 13, 0, 13, 4, 35, 3, 36, 16, 1, 1, 1, 1, 1,
        0, 3, 3, 1, 45, 2, 1, 43, 4, 35, 1, 1, 1, 1, 1,
        0, 0, 17, 36, 46, 33, 35, 2, 2, 17, 1, 1, 1, 1, 1,
        0, 0, 0, 17, 1, 43, 35, 15, 43, 1, 1, 1, 1, 1, 1,
        0, 0, 0, 0, 0, 1, 0, 1, 34, 12, 36, 1, 1, 1, 1,
        0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
        0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 15,
      height = 10,
      id = 2,
      name = "render1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146,
        146, 95, 95, 95, 98, 82, 96, 98, 97, 96, 98, 96, 95, 95, 146,
        146, 97, 82, 95, 82, 96, 96, 96, 95, 96, 96, 98, 82, 95, 146,
        146, 98, 98, 98, 98, 97, 96, 95, 98, 95, 82, 97, 98, 98, 146,
        146, 98, 97, 95, 98, 96, 98, 82, 96, 95, 97, 98, 96, 98, 56,
        146, 98, 82, 95, 97, 82, 97, 98, 97, 95, 97, 95, 95, 95, 56,
        146, 96, 96, 96, 95, 96, 98, 96, 95, 98, 97, 95, 95, 97, 146,
        146, 82, 97, 97, 96, 98, 82, 95, 95, 96, 97, 96, 97, 97, 146,
        146, 95, 96, 98, 96, 96, 98, 96, 97, 96, 95, 98, 95, 97, 146,
        146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "screensize",
      class = "",
      visible = true,
      opacity = 0.3,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      tintcolor = { 16, 170, 255 },
      properties = {},
      objects = {
        {
          id = 15,
          name = "playdateScreen",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 400,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 1,
      name = "entry",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 4,
          name = "default",
          type = "",
          shape = "rectangle",
          x = 336,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "east",
          type = "",
          shape = "rectangle",
          x = 448,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "exit",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 18,
          name = "r1a001-west",
          type = "",
          shape = "rectangle",
          x = 464,
          y = 128,
          width = 32,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
