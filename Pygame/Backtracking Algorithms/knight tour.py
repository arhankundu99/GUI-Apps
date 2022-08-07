import pygame

pygame.init()

width_of_screen = 800
height_of_screen = 800
dif = 100
width_of_cell = width_of_screen//8
height_of_cell = height_of_screen//8

font = pygame.font.SysFont("comicsans", 40)
n = 8
board = [[-1 for i in range(n)] for i in range(n)]
screen = pygame.display.set_mode((width_of_screen, height_of_screen))


def draw_val(y, x, value):
    text1 = font.render(str(value), 100, (0, 0, 0))
    screen.blit(text1, (x * dif + 15, y * dif + 15))
    update_display()


def update_display():
    pygame.display.update()


def draw_board():
    thickness = 7
    for i in range(0, 8):
        # draw horizontal lines
        pygame.draw.line(screen, (0, 0, 0), (0, i * width_of_cell), (width_of_screen, i * width_of_cell), thickness)
        # draw vertical lines
        pygame.draw.line(screen, (0, 0, 0), (i * width_of_cell, 0), (i * width_of_cell, height_of_screen), thickness)

    for i in range(0, 8):
        for j in range(0, 8):
            if board[i][j] != -1:
                draw_val(i, j, board[i][j])
    update_display()


def isSafe(x, y, board):
    if x >= 0 and y >= 0 and x < n and y < n and board[x][y] == -1:
        return True
    return False


def printSolution(n, board):
    for i in range(n):
        for j in range(n):
            print(board[i][j], end=' ')
        print()


def solveKT(n):

    move_x = [2, 1, -1, -2, -2, -1, 1, 2]
    move_y = [1, 2, 2, 1, -1, -2, -2, -1]

    board[0][0] = 0

    pos = 1
    if not solveKTUtil(n, board, 0, 0, move_x, move_y, pos):
        print("Solution does not exist")
    else:
        printSolution(n, board)


def solveKTUtil(n, board, curr_x, curr_y, move_x, move_y, pos):

    flag = True

    for i in range(0, n):
        for j in range(0, n):
            if board[i][j] == -1:
                flag = False
                break
    if flag:
        return True

    for i in range(8):
        new_x = curr_x + move_x[i]
        new_y = curr_y + move_y[i]
        if isSafe(new_x, new_y, board):
            board[new_x][new_y] = pos
            draw_val(new_x, new_y, pos)
            if solveKTUtil(n, board, new_x, new_y, move_x, move_y, pos + 1):
                return True

            # Backtracking
            board[new_x][new_y] = -1

            draw_board()

    return False


screen.fill((255, 255, 255))
draw_board()
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_RETURN:
                solveKT(8)
