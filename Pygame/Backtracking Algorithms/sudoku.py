# import pygame library
import pygame

# initialise the pygame font
pygame.init()

# set screen size
screen = pygame.display.set_mode((500, 600))
# 500 is width and 600 is height

# set title and Icon
pygame.display.set_caption("Automatic Sudoku Solver")
img = pygame.image.load('images/logo.png')
pygame.display.set_icon(img)

# current coordinates of cell
x = 0
y = 0

# dif is the width and height of each cell
dif = 500 / 9

# val is the value of a cell
val = 0

# Default Sudoku Board.
grid = [
    [7, 8, 0, 4, 0, 0, 1, 2, 0],
    [6, 0, 0, 0, 7, 5, 0, 0, 9],
    [0, 0, 0, 6, 0, 1, 0, 7, 8],
    [0, 0, 7, 0, 4, 0, 2, 6, 0],
    [0, 0, 1, 0, 5, 0, 9, 3, 0],
    [9, 0, 4, 0, 6, 0, 0, 0, 5],
    [0, 7, 0, 3, 0, 0, 0, 1, 2],
    [1, 2, 0, 0, 0, 7, 4, 0, 0],
    [0, 4, 9, 2, 0, 6, 0, 0, 7]
]

# Load test fonts for future use
font1 = pygame.font.SysFont("comicsans", 40)
# font1 is used for numbers

# font2 is used for text
font2 = pygame.font.SysFont("comicsans", 20)


# returns the x coordinate and y coordinate of the selected cell (0 based)
def get_cord(pos):
    global x
    x = pos[0] // dif
    global y
    y = pos[1] // dif


# Highlight the selected cell
def draw_box():
    for i in range(2):
        # draw upper and lower horizontal line for the selected cell
        pygame.draw.line(screen, (255, 0, 0), (x * dif - 3, (y + i) * dif), (x * dif + dif + 3, (y + i) * dif), 7)

        # draw left and right vertical line for the selected cell
        pygame.draw.line(screen, (255, 0, 0), ((x + i) * dif, y * dif), ((x + i) * dif, y * dif + dif), 7)

    # Function to draw required lines for making Sudoku grid


def draw():
    # Draw the lines
    for i in range(9):
        for j in range(9):
            if grid[i][j] != 0:
                # Fill blue color in already numbered grid
                pygame.draw.rect(screen, (0, 153, 153), (i * dif, j * dif, dif + 1, dif + 1))

                # Fill gird with default numbers specified
                text1 = font1.render(str(grid[i][j]), 1, (0, 0, 0))
                screen.blit(text1, (i * dif + 15, j * dif + 15))

    # Draw lines horizontally and vertically to form grid
    for i in range(10):
        if i % 3 == 0:
            thickness = 7
        else:
            thickness = 1

        # draw vertical lines
        pygame.draw.line(screen, (0, 0, 0), (0, i * dif), (500, i * dif), thickness)
        # draw horizontal lines
        pygame.draw.line(screen, (0, 0, 0), (i * dif, 0), (i * dif, 500), thickness)


# Fill value entered in cell
def draw_val(value):
    text1 = font1.render(str(value), 100, (0, 0, 0))
    screen.blit(text1, (x * dif + 15, y * dif + 15))


# Raise error when wrong value is entered
def raise_error1():
    text1 = font1.render("WRONG !!!", 1, (0, 0, 0))
    screen.blit(text1, (20, 570))


def raise_error2():
    text1 = font1.render("Wrong !!! Not a valid Key", 1, (0, 0, 0))
    screen.blit(text1, (20, 570))


# Check if the value entered in board is valid
def isValid(m, r, c, value):
    if isValidRow(m, r, c, value) and isValidCol(m, r, c, value) and isValidBox(m, r, c, value):
        return True
    return False


def isValidRow(m, r, c, value):
    for i in range(9):
        if m[r][i] == value:
            return False
    return True


def isValidCol(m, r, c, value):
    for i in range(9):
        if m[i][c] == value:
            return False
    return True


def isValidBox(m, r, c, value):
    startR = (r // 3) * 3
    startC = (c // 3) * 3

    for i in range(startR, startR+3):
        for j in range(startC, startC+3):
            if m[i][j] == value:
                return False
    return True


# Solves the sudoku board using Backtracking Algorithm
def solve(grid):
    # if the grid is full, return true, else find empty cell
    r = 0
    c = 0
    while c < 9 and r < 9 and grid[r][c] != 0:
        r = r+1
        if r == 9:
            r = 0
            c = c+1
        if c == 9:
            return True

    pygame.event.pump()

    # fill value in empty cell
    for value in range(1, 10):
        if isValid(grid, r, c, value):
            grid[r][c] = value

            # store the current cell coordinates (To mark the current cell)
            global x, y
            x = r
            y = c

            # white color background
            screen.fill((255, 255, 255))

            # update display
            draw()
            draw_box()
            pygame.display.update()
            pygame.time.delay(50)

            # dfs
            if solve(grid) == 1:
                return True
            else:
                # backtrack
                grid[r][c] = 0

            # white color background
            screen.fill((255, 255, 255))

            # update display
            draw()
            draw_box()
            pygame.display.update()
            pygame.time.delay(50)

    return False


# Display instruction for the game
def instruction():
    text1 = font2.render("PRESS D TO RESET TO DEFAULT / R TO EMPTY", 1, (0, 0, 0))
    text2 = font2.render("ENTER VALUES AND PRESS ENTER TO VISUALIZE", 1, (0, 0, 0))
    screen.blit(text1, (20, 520))
    screen.blit(text2, (20, 540))


# Display options when solved
def result():
    text1 = font1.render("FINISHED PRESS R or D", 1, (0, 0, 0))
    screen.blit(text1, (20, 570))


running = True
flag1 = 0  # flag1 = 1 denotes we have manually clicked a cell in the grid
flag2 = 0  # flag2 = 1 denotes we have pressed enter button, so the sudoku will be filled automatically
rs = 0  # rs = 1 denotes that the sudoku is completely solved
error = 0  # error = 1 denotes an error has occurred while filling a cell in sudoku

# The loop that keeps the window running
while running:

    # White color background
    screen.fill((255, 255, 255))

    # Loop through the events stored in event.get()
    for event in pygame.event.get():
        # Quit the game window
        if event.type == pygame.QUIT:
            running = False

        # Get the mouse position to insert number
        if event.type == pygame.MOUSEBUTTONDOWN:
            flag1 = 1
            pos = pygame.mouse.get_pos()

            # get_cord(pos) sets global x to column of the cell and global y to row of the cell
            get_cord(pos)

        # Get the number to be inserted if key pressed
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_LEFT:
                x -= 1
                flag1 = 1
            if event.key == pygame.K_RIGHT:
                x += 1
                flag1 = 1
            if event.key == pygame.K_UP:
                y -= 1
                flag1 = 1
            if event.key == pygame.K_DOWN:
                y += 1
                flag1 = 1
            if event.key == pygame.K_1:
                val = 1
            if event.key == pygame.K_2:
                val = 2
            if event.key == pygame.K_3:
                val = 3
            if event.key == pygame.K_4:
                val = 4
            if event.key == pygame.K_5:
                val = 5
            if event.key == pygame.K_6:
                val = 6
            if event.key == pygame.K_7:
                val = 7
            if event.key == pygame.K_8:
                val = 8
            if event.key == pygame.K_9:
                val = 9
            if event.key == pygame.K_RETURN:
                flag2 = 1

            # If R is pressed clear the sudoku board
            if event.key == pygame.K_r:
                rs = 0
                error = 0
                flag2 = 0
                grid = [
                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0, 0, 0]
                ]

            # If D is pressed reset the board to default
            if event.key == pygame.K_d:
                rs = 0
                error = 0
                flag2 = 0
                grid = [
                    [7, 8, 0, 4, 0, 0, 1, 2, 0],
                    [6, 0, 0, 0, 7, 5, 0, 0, 9],
                    [0, 0, 0, 6, 0, 1, 0, 7, 8],
                    [0, 0, 7, 0, 4, 0, 2, 6, 0],
                    [0, 0, 1, 0, 5, 0, 9, 3, 0],
                    [9, 0, 4, 0, 6, 0, 0, 0, 5],
                    [0, 7, 0, 3, 0, 0, 0, 1, 2],
                    [1, 2, 0, 0, 0, 7, 4, 0, 0],
                    [0, 4, 9, 2, 0, 6, 0, 0, 7]
                ]

    # flag2 denotes that we have pressed enter button
    # automatic solving
    if flag2 == 1:
        if not solve(grid):
            error = 1
        else:
            rs = 1
        # set flag2 to 0
        flag2 = 0

    # manual solving
    if val != 0:
        draw_val(val)
        if isValid(grid, int(x), int(y), val):
            grid[int(x)][int(y)] = val
            flag1 = 0
        else:
            grid[int(x)][int(y)] = 0
            raise_error2()
        val = 0

    if error == 1:
        raise_error1()
    if rs == 1:
        result()
    if flag1 == 1:
        draw_box()

    draw()
    instruction()

    # Update window
    pygame.display.update()

# Quit pygame window
pygame.quit()


