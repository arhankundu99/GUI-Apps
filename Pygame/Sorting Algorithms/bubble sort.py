import pygame
import random

pygame.init()

arr = []
x = 40
y = 40
width = 20

screen = pygame.display.set_mode((700, 700))
screen.fill((255, 255, 255))
font = pygame.font.SysFont("comicsans", 40)


def reset_arr():
    for i in range(0, 20):
        arr.append(100*(random.random()+0.05))


def show_arr():
    for i in range(0, 20):
        pygame.draw.rect(screen, (255, 0, 0), (x + 30 * i, y, width, arr[i]*5))
    update_display()


def update_display():
    pygame.display.update()


def show_initial_text():
    text = font.render("Press enter to start", 1, (0, 0, 0))
    screen.blit(text, (220, 570))
    update_display()


def swap(i, j):
    temp = arr[i]
    arr[i] = arr[j]
    arr[j] = temp


def bubble_sort():
    for i in range(len(arr)-1, 0, -1):
        for j in range(0, i):
            if arr[j] > arr[j+1]:
                swap(j, j+1)
            screen.fill((255, 255, 255))
            show_arr()
            pygame.time.wait(50)

    print(arr)


def show_reset_text():
    text = font.render("Press R to reset", 1, (0, 0, 0))
    screen.blit(text, (220, 570))
    update_display()


reset_arr()
show_initial_text()
show_arr()
update_display()
running = True
while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_RETURN:
                    bubble_sort()
                    show_reset_text()
                if event.key == pygame.K_r:
                    arr = []
                    screen.fill((255, 255, 255))
                    reset_arr()
                    show_initial_text()
                    show_arr()
                    update_display()
