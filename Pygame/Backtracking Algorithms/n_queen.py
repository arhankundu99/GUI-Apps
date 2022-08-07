import pygame

pygame.init()

width_of_screen = 800
height_of_screen = 800

width_of_cell = width_of_screen//8
height_of_cell = height_of_screen//8

font = pygame.font.SysFont("comicsans", 40)

screen = pygame.display.set_mode((width_of_screen, height_of_screen))

grid = [
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
    ]


def draw_chess_board():
    thickness = 7
    for i in range(0, 8):
        # draw horizontal lines
        pygame.draw.line(screen, (0, 0, 0), (0, i * width_of_cell), (width_of_screen, i * width_of_cell), thickness)
        # draw vertical lines
        pygame.draw.line(screen, (0, 0, 0), (i * width_of_cell, 0), (i * width_of_cell, height_of_screen), thickness)
    update_display()


def update_display():
    pygame.display.update()


def draw_queen(x, y):
    x = x*width_of_cell
    y = y*height_of_cell
    Q = font.render("Q", 100, (0, 0, 0))
    screen.blit(Q, (x+30, y+30))
    update_display()


def highlight_cell(x, y):
    thickness = 10
    pygame.draw.line(screen, (255, 0, 0), (x * width_of_cell, y*height_of_cell), ((x+1)*width_of_cell, y * height_of_cell), thickness)
    pygame.draw.line(screen, (255, 0, 0), (x * width_of_cell, (y+1)*height_of_cell), ((x + 1) * width_of_cell, (y+1) * height_of_cell), thickness)

    pygame.draw.line(screen, (255, 0, 0), (x * width_of_cell, y * height_of_cell), (x * width_of_cell, (y+1) * height_of_cell), thickness)
    pygame.draw.line(screen, (255, 0, 0), ((x+1) * width_of_cell, y * height_of_cell),
                     ((x+1) * width_of_cell, (y + 1) * height_of_cell), thickness)


def draw():
    for i in range(0, 8):
        for j in range(0, 8):
            if grid[i][j] == 1:
                draw_queen(j, i)


def isSafe(row, col):
    for i in range(0, 8):
        if grid[row][i] == 1:
            return False

    for i in range(0, 8):
        if grid[i][col] == 1:
            return False

    for i, j in zip(range(row, -1, -1),
                    range(col, -1, -1)):
        if grid[i][j] == 1:
            return False

    for i, j in zip(range(row, 8, 1),
                    range(col, -1, -1)):
        if grid[i][j] == 1:
            return False

    return True


def solve(count):
    print(count)
    if count == 8:
        return True

    for i in range(0, 8):
        for j in range(0, 8):
            if isSafe(i, j):
                grid[i][j] = 1
                highlight_cell(j, i)
                draw()
                pygame.time.delay(1000)
                if solve(count+1):
                    return True
                grid[i][j] = 0
                screen.fill((255, 255, 255))
                draw_chess_board()
                draw()

                pygame.time.delay(1000)

    return False


screen.fill((255, 255, 255))
draw_chess_board()
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_RETURN:
                grid = [
                    [0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0]
                ]
                solve(0)
