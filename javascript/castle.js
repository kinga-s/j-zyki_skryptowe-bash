player.onChat("run", function () {

})

let castleDict = {
    "size": 28,
    "start": 5,
    "fossThickness": 4,
    "floorHeight": 5,
    "towerHeight": 4
}


function buildCastle(castle: any) {
    let start = castle["start"];
    let buildSize = castle["size"];
    let end = buildSize + start;
    let fossThickness = castle["fossThickness"];
    let floorHeight = castle["floorHeight"];
    let towerHeight = castle["towerHeight"];

    //base
    blocks.fill(GRASS, pos(start, 0, start), pos(end, 0, end), FillOperation.Replace)
    makeSquare(GRASS, start, 1, start, end, 5, end);
    blocks.fill(GRASS, pos(start + fossThickness + 1, 0, start + fossThickness + 1), pos(end - fossThickness - 1, 5, end - fossThickness - 1), FillOperation.Replace)

    //castle
    let castleStart = start + fossThickness + 4;
    let castleEnd = end - fossThickness - 4;
    let ground = 5
    let firstFloor = ground + 7;
    let secondFloor = firstFloor + floorHeight;
    let roof = secondFloor + floorHeight;

    makeSquare(DOUBLE_STONE_SLAB, castleStart, ground, castleStart, castleEnd, roof + 1, castleEnd);

    //windows
    replaceSquare(GLASS_PANE, DOUBLE_STONE_SLAB, castleStart, 10, castleStart, castleEnd, 10, castleEnd)
    blocks.fill(GLASS_PANE, pos(castleStart + 1, secondFloor + 3, castleEnd), pos(castleEnd - 1, secondFloor + 3, castleEnd), FillOperation.Replace)

    //towers
    replaceSquare(AIR, DOUBLE_STONE_SLAB, castleStart, roof+1, castleStart, castleEnd, roof+1, castleEnd)
    makeSquare(DOUBLE_STONE_SLAB, castleStart, roof + 1, castleStart, castleStart + 2, roof + towerHeight, castleStart + 2)
    makeSquare(DOUBLE_STONE_SLAB, castleEnd - 2, roof + 1, castleStart, castleEnd, roof + towerHeight, castleStart + 2)
    replaceSquare(AIR, DOUBLE_STONE_SLAB, castleStart, roof + towerHeight, castleStart, castleStart + 2, roof + towerHeight, castleStart + 2)
    replaceSquare(AIR, DOUBLE_STONE_SLAB, castleEnd - 2, roof + towerHeight, castleStart, castleEnd, roof + towerHeight, castleStart + 2)

    //stairs
    makeStairs(7, castleStart + 2, ground+1, castleEnd + 1)
    makeStairs(floorHeight, castleStart + 2, firstFloor + 1, castleStart - 1)

    //floors
    blocks.fill(OBSIDIAN, pos(castleStart + 1, ground, castleStart + 1), pos(castleEnd - 1, ground, castleEnd - 1), FillOperation.Replace)
    blocks.fill(DOUBLE_WOODEN_SLAB, pos(castleStart + 1, firstFloor, castleStart + 1), pos(castleEnd - 1, firstFloor, castleEnd - 1), FillOperation.Replace)
    blocks.fill(GOLD_BLOCK, pos(castleStart + 1, secondFloor, castleStart + 1), pos(castleEnd - 1, secondFloor, castleEnd - 1), FillOperation.Replace)
    blocks.fill(BRICKS, pos(castleStart + 1, roof, castleStart + 1), pos(castleEnd - 1, roof, castleEnd - 1), FillOperation.Replace)

    //enters
    blocks.replace(AIR, DOUBLE_STONE_SLAB, pos(castleStart + 1, ground+1, castleEnd), pos(castleStart + 1, ground+2, castleEnd))
    blocks.replace(AIR, DOUBLE_STONE_SLAB, pos(castleStart + 2 + 7, firstFloor+1, castleEnd), pos(castleStart + 2 + 7, firstFloor+2, castleEnd))
    blocks.replace(AIR, DOUBLE_STONE_SLAB, pos(castleStart + 1, firstFloor+1, castleStart), pos(castleStart + 1, firstFloor + 2, castleStart))
    blocks.replace(AIR, DOUBLE_STONE_SLAB, pos(castleStart + 2 + floorHeight, secondFloor+1, castleStart), pos(castleStart + 2 + floorHeight, secondFloor + 2, castleStart))

    //ladders
    blocks.fill(LADDER, pos(castleStart + 1, secondFloor+1, castleStart + 1), pos(castleStart + 1, roof+towerHeight-1, castleStart + 1))
    blocks.fill(LADDER, pos(castleEnd - 1, secondFloor + 1, castleStart + 1), pos(castleEnd-1, roof + towerHeight - 1, castleStart + 1))

    //foss
    makeFoss(start, end, fossThickness)
}

function makeStairs(height: number, x0: number, y0: number, z0: number) {
    blocks.fill(DOUBLE_STONE_SLAB, pos(x0 - 1, y0 - 1, z0), pos(x0, y0 - 1, z0), FillOperation.Replace)

    for (let i = 0; i < height; i++) {
        blocks.place(DOUBLE_STONE_SLAB, pos(x0 + i + 1, y0 + i, z0))
        blocks.place(SPRUCE_WOOD_STAIRS, pos(x0 + i, y0 + i, z0))
    }
}

function replaceSquare(newBlock: any, oldBlock: any, x0: number, y0: number, z0: number, x1: number, y1: number, z1: number) {
    let wallSize = x1 - x0;
    for (let i = 0; i < wallSize; i++) {
        if (i % 2 == 1) {
            blocks.replace(newBlock, oldBlock, pos(x0 + i, y0, z0), pos(x0 + i, y1, z0))
            blocks.replace(newBlock, oldBlock, pos(x0, y0, z0 + i), pos(x0, y1, z0 + i))
            blocks.replace(newBlock, oldBlock, pos(x0 + i, y0, z1), pos(x0 + i, y1, z1))
            blocks.replace(newBlock, oldBlock, pos(x1, y0, z0 + i), pos(x1, y1, z0 + i))
        }
    }
}


function makeSquare(block_type: any, x0: number, y0: number, z0: number, x1: number, y1: number, z1: number) {
    blocks.fill(block_type, pos(x0, y0, z0), pos(x1, y1, z0), FillOperation.Replace)
    blocks.fill(block_type, pos(x1, y0, z0), pos(x1, y1, z1), FillOperation.Replace)
    blocks.fill(block_type, pos(x0, y0, z1), pos(x1, y1, z1), FillOperation.Replace)
    blocks.fill(block_type, pos(x0, y0, z0), pos(x0, y1, z1), FillOperation.Replace)
}

function makeFoss(start: number, end: number, thick: number) {
    let avg = (start + end) / 2;

    for (let i = 1; i <= thick; i++) {
        makeSquare(WATER, start + i, 1, start + i, end - i, 4, end - i);
    }

    blocks.fill(PLANKS_DARK_OAK, pos(avg - 1, 5, start + 1), pos(avg + 1, 5, start + thick), FillOperation.Replace)
    blocks.fill(OAK_FENCE, pos(avg - 1, 6, start + 1), pos(avg - 1, 6, start + thick), FillOperation.Replace)
    blocks.fill(OAK_FENCE, pos(avg + 1, 6, start + 1), pos(avg + 1, 6, start + thick), FillOperation.Replace)
    blocks.replace(OAK_FENCE, DOUBLE_STONE_SLAB, pos(avg - 1, 6, start + thick + 4), pos(avg + 1, 8, start + thick + 4))
}

buildCastle(castleDict);